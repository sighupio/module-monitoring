#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${MINIO_VERSION:-}" ]; then
  echo "Usage: MINIO_VERSION=RELEASE.2026-05-20T23-44-52Z MC_VERSION=RELEASE.2025-08-13T08-35-41Z PROMETHEUS_ALERTS_VERSION=2026-04-10.1 ./upgrade.sh"
  exit 1
fi
MINIO_IMAGE_TAG="${MINIO_VERSION}-chainguard"
echo "Using MinIO version ${MINIO_VERSION} with image tag ${MINIO_IMAGE_TAG}"

if [ -z "${MC_VERSION:-}" ]; then
  echo "Usage: MINIO_VERSION=RELEASE.2026-05-20T23-44-52Z MC_VERSION=RELEASE.2025-08-13T08-35-41Z PROMETHEUS_ALERTS_VERSION=2026-04-10.1 ./upgrade.sh"
  exit 1
fi
echo "Using MC version ${MC_VERSION}"

if [ -z "${PROMETHEUS_ALERTS_VERSION:-}" ]; then
  echo "Usage: MINIO_VERSION=RELEASE.2026-05-20T23-44-52Z MC_VERSION=RELEASE.2025-08-13T08-35-41Z PROMETHEUS_ALERTS_VERSION=2026-04-10.1 ./upgrade.sh"
  exit 1
fi
echo "Using Prometheus alerts version ${PROMETHEUS_ALERTS_VERSION}"

# --- MinIO ---
mkdir -p /tmp/minio-chainguard
curl -sL "https://api.github.com/repos/chainguard-forks/minio/tarball/${MINIO_VERSION}" -o /tmp/minio-chainguard/release.tar.gz
echo "Downloaded archive"

tar xf /tmp/minio-chainguard/release.tar.gz -C /tmp/minio-chainguard --strip-components=1
echo "Extracted archive"

helm lint /tmp/minio-chainguard/helm/minio --values MAINTENANCE.values.yaml
echo "Helm lint done"

yq -i "(.images[] | select(.name == \"registry.sighup.io/fury/minio/mc\")).newTag = \"${MC_VERSION}\"" kustomization.yaml
echo "Updated image tags in kustomization.yaml"

yq -i ".image.tag = \"${MINIO_IMAGE_TAG}\"" MAINTENANCE.values.yaml
yq -i ".mcImage.tag = \"${MC_VERSION}\"" MAINTENANCE.values.yaml
echo "Updated image tags in MAINTENANCE.values.yaml"

helm template minio-monitoring /tmp/minio-chainguard/helm/minio --values MAINTENANCE.values.yaml -n monitoring \
  | yq 'select(.kind != "ConfigMap" or .metadata.name != "minio-monitoring")' > deploy.yaml
echo "Template generated in deploy.yaml"

# --- Prometheus rules ---
MINIO_RULES_FILE=$(mktemp -p /tmp)
wget -q "https://raw.githubusercontent.com/samber/awesome-prometheus-alerts/refs/tags/${PROMETHEUS_ALERTS_VERSION}/dist/rules/minio/embedded-exporter.yml" -O "${MINIO_RULES_FILE}"
echo "Downloaded MinIO Prometheus rules from upstream"

yq -i ".spec.groups = load(\"${MINIO_RULES_FILE}\").groups" prometheusrules.yaml
rm -f "${MINIO_RULES_FILE}"
sed -i '' -E 's/(minio_[a-z_]+) /\1{job="minio-monitoring"} /g' prometheusrules.yaml
yq -i '(.spec.groups[].rules[] | select(.alert == "MinioDiskSpaceUsage")).for = "5m"' prometheusrules.yaml
echo "MinIO Prometheus rules updated"

rm -r /tmp/minio-chainguard
mise run add-license

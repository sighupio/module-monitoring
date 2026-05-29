#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${MINIO_VERSION:-}" ]; then
  echo "Usage: MINIO_VERSION=RELEASE.2026-05-20T23-44-52Z MC_VERSION=RELEASE.2025-08-13T08-35-41Z ./upgrade.sh"
  exit 1
fi
MINIO_IMAGE_TAG="${MINIO_VERSION}-chainguard"
echo "Using MinIO version ${MINIO_VERSION} with image tag ${MINIO_IMAGE_TAG}"

if [ -z "${MC_VERSION:-}" ]; then
  echo "Usage: MINIO_VERSION=RELEASE.2026-05-20T23-44-52Z MC_VERSION=RELEASE.2025-08-13T08-35-41Z ./upgrade.sh"
  exit 1
fi
echo "Using MC version ${MC_VERSION}"

mkdir -p /tmp/minio-chainguard
curl -sL "https://api.github.com/repos/chainguard-forks/minio/tarball/${MINIO_VERSION}" -o /tmp/minio-chainguard/release.tar.gz
echo "Downloaded archive"

tar xf /tmp/minio-chainguard/release.tar.gz -C /tmp/minio-chainguard --strip-components=1
echo "Extracted archive"

helm lint /tmp/minio-chainguard/helm/minio --values MAINTENANCE.values.yaml
echo "Helm lint done"

yq -i ".image.tag = \"${MINIO_IMAGE_TAG}\"" MAINTENANCE.values.yaml
yq -i ".mcImage.tag = \"${MC_VERSION}\"" MAINTENANCE.values.yaml
echo "Updated image tags in MAINTENANCE.values.yaml"

yq -i "(.images[] | select(.name == \"quay.io/minio/minio\")).newTag = \"${MINIO_IMAGE_TAG}\"" kustomization.yaml
yq -i "(.images[] | select(.name == \"quay.io/minio/mc\")).newTag = \"${MC_VERSION}\"" kustomization.yaml
echo "Updated image tags in kustomization.yaml"

helm template minio-monitoring /tmp/minio-chainguard/helm/minio --values MAINTENANCE.values.yaml -n monitoring \
  | yq 'select(.kind != "ConfigMap" or .metadata.name != "minio-monitoring")' > deploy.yaml
echo "Template generated in deploy.yaml"

rm -r /tmp/minio-chainguard
mise run add-license

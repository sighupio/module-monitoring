#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

MINIO_RELEASE=$(curl -sL "https://api.github.com/repos/chainguard-forks/minio/releases/latest" | jq -r ".tag_name")
MINIO_TAG="${MINIO_RELEASE}-chainguard"
echo "Found latest MinIO release $MINIO_RELEASE. MinIO tag will be $MINIO_TAG"

MC_RELEASE=$(curl -sL "https://api.github.com/repos/minio/mc/releases/latest" | jq -r ".tag_name")
echo "Found latest MC release $MC_RELEASE"

mkdir -p /tmp/minio-chainguard
curl -sL "https://api.github.com/repos/chainguard-forks/minio/tarball/${MINIO_RELEASE}" -o /tmp/minio-chainguard/release.tar.gz
echo "Downloaded archive"

tar xf /tmp/minio-chainguard/release.tar.gz -C /tmp/minio-chainguard --strip-components=1
echo "Extracted archive"

helm lint /tmp/minio-chainguard/helm/minio --values MAINTENANCE.values.yaml
echo "Helm lint done"

yq -i ".image.tag = \"${MINIO_TAG}\"" MAINTENANCE.values.yaml
yq -i ".mcImage.tag = \"${MC_RELEASE}\"" MAINTENANCE.values.yaml
echo "Updated image tags in MAINTENANCE.values.yaml"

yq -i "(.images[] | select(.name == \"quay.io/minio/minio\")).newTag = \"${MINIO_TAG}\"" kustomization.yaml
yq -i "(.images[] | select(.name == \"quay.io/minio/mc\")).newTag = \"${MC_RELEASE}\"" kustomization.yaml
echo "Updated image tags in kustomization.yaml"

helm template minio-monitoring /tmp/minio-chainguard/helm/minio --values MAINTENANCE.values.yaml -n monitoring \
  | yq 'select(.kind != "ConfigMap" or .metadata.name != "minio-monitoring")' > deploy.yaml
echo "Template generated in deploy.yaml"

rm -r /tmp/minio-chainguard
mise run add-license

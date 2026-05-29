#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${RBAC_PROXY_VERSION:-}" ]; then
  echo "Usage: RBAC_PROXY_VERSION=v0.22.0 ./upgrade.sh"
  exit 1
fi
echo "Using image version ${RBAC_PROXY_VERSION}"

yq -i "(.images[] | select(.name == \"kube-rbac-proxy\")).newTag = \"${RBAC_PROXY_VERSION}\"" kustomization.yaml
echo "Kube RBAC proxy updated to ${RBAC_PROXY_VERSION}"

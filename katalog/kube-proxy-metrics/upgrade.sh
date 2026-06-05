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

kustomize edit set image kube-rbac-proxy=registry.sighup.io/fury/brancz/kube-rbac-proxy:${RBAC_PROXY_VERSION}
echo "Kube RBAC proxy updated to ${RBAC_PROXY_VERSION}"

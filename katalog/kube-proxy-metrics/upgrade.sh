#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

RBAC_PROXY_RELEASE=$(curl -sL "https://api.github.com/repos/kube-rbac-proxy/kube-rbac-proxy/releases/latest" | jq -r ".tag_name")
echo "Found latest Kube RBAC Proxy ${RBAC_PROXY_RELEASE}"

yq -i "(.images[] | select(.name == \"kube-rbac-proxy\")).newTag = \"${RBAC_PROXY_RELEASE}\"" kustomization.yaml
echo "Kube RBAC proxy updated to ${RBAC_PROXY_RELEASE}"

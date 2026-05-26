#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${KUBE_PROMETHEUS_RELEASE:-}" ]; then
  echo "Usage: KUBE_PROMETHEUS_RELEASE=v0.17.0 ./upgrade.sh"
  exit 1
fi

../../utils/pull-upstream.sh "${KUBE_PROMETHEUS_RELEASE}" prometheus-adapter

yq '.data."config.yaml"' configMap.yaml > config.yaml
rm configMap.yaml
echo "Patched config.yml"

LABELS_FILE=$(mktemp)
yq '.metadata.labels' apiService.yaml > "${LABELS_FILE}"
yq -i "del(.metadata.labels) | .metadata.labels = load(\"${LABELS_FILE}\")" apiService-EnhancedHPAMetrics.yaml
rm -f "${LABELS_FILE}"
echo "Updated labels in apiService-EnhancedHPAMetrics.yaml"

mise run add-license
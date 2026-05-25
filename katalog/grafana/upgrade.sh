#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${KUBE_PROMETHEUS_RELEASE:-}" ]; then
  echo "Usage: KUBE_PROMETHEUS_RELEASE=v0.17.0 ./upgrade.sh"
  exit 1
fi

../../utils/pull-upstream.sh "${KUBE_PROMETHEUS_RELEASE}" grafana

# Remove Windows/AIX volumeMounts
yq -i 'del(.spec.template.spec.containers[].volumeMounts[] | select(.name == "grafana-dashboard-k8s-resources-windows-cluster"))' deployment.yaml
yq -i 'del(.spec.template.spec.containers[].volumeMounts[] | select(.name == "grafana-dashboard-k8s-resources-windows-namespace"))' deployment.yaml
yq -i 'del(.spec.template.spec.containers[].volumeMounts[] | select(.name == "grafana-dashboard-k8s-resources-windows-pod"))' deployment.yaml
yq -i 'del(.spec.template.spec.containers[].volumeMounts[] | select(.name == "grafana-dashboard-k8s-windows-cluster-rsrc-use"))' deployment.yaml
yq -i 'del(.spec.template.spec.containers[].volumeMounts[] | select(.name == "grafana-dashboard-k8s-windows-node-rsrc-use"))' deployment.yaml
yq -i 'del(.spec.template.spec.containers[].volumeMounts[] | select(.name == "grafana-dashboard-nodes-aix"))' deployment.yaml

# Remove Windows/AIX volumes
yq -i 'del(.spec.template.spec.volumes[] | select(.name == "grafana-dashboard-k8s-resources-windows-cluster"))' deployment.yaml
yq -i 'del(.spec.template.spec.volumes[] | select(.name == "grafana-dashboard-k8s-resources-windows-namespace"))' deployment.yaml
yq -i 'del(.spec.template.spec.volumes[] | select(.name == "grafana-dashboard-k8s-resources-windows-pod"))' deployment.yaml
yq -i 'del(.spec.template.spec.volumes[] | select(.name == "grafana-dashboard-k8s-windows-cluster-rsrc-use"))' deployment.yaml
yq -i 'del(.spec.template.spec.volumes[] | select(.name == "grafana-dashboard-k8s-windows-node-rsrc-use"))' deployment.yaml
yq -i 'del(.spec.template.spec.volumes[] | select(.name == "grafana-dashboard-nodes-aix"))' deployment.yaml

echo "Deployment patched"

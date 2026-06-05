#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${KUBE_PROMETHEUS_RELEASE:-}" ]; then
  echo "Usage: KUBE_PROMETHEUS_RELEASE=v0.17.0 K8S_SIDECAR_VERSION=2.7.3 DRILLDOWN_VERSION=2.0.4 ./upgrade.sh"
  exit 1
fi
echo "Using kube-prometheus version ${KUBE_PROMETHEUS_RELEASE}"

if [ -z "${K8S_SIDECAR_VERSION:-}" ]; then
  echo "Usage: KUBE_PROMETHEUS_RELEASE=v0.17.0 K8S_SIDECAR_VERSION=2.7.3 DRILLDOWN_VERSION=2.0.4 ./upgrade.sh"
  exit 1
fi
echo "Using k8s-sidecar version ${K8S_SIDECAR_VERSION}"

if [ -z "${DRILLDOWN_VERSION:-}" ]; then
  echo "Usage: KUBE_PROMETHEUS_RELEASE=v0.17.0 K8S_SIDECAR_VERSION=2.7.3 DRILLDOWN_VERSION=2.0.4 ./upgrade.sh"
  exit 1
fi
echo "Using drilldown version ${DRILLDOWN_VERSION}"

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

kustomize edit set image kiwigrid/k8s-sidecar=registry.sighup.io/fury/kiwigrid/k8s-sidecar:${K8S_SIDECAR_VERSION}
echo "K8S sidecar updated to ${K8S_SIDECAR_VERSION}"

yq -i "(.spec.template.spec.containers[].env[] | select(.name == \"GF_INSTALL_PLUGINS\")).value = \"https://storage.googleapis.com/integration-artifacts/grafana-lokiexplore-app/release/${DRILLDOWN_VERSION}/any/grafana-lokiexplore-app-${DRILLDOWN_VERSION}.zip;grafana-lokiexplore-app\"" patches/grafana-env.yaml
echo "Drilldown plugin updated to ${DRILLDOWN_VERSION}"
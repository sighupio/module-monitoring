#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${X509_CHART_VERSION:-}" ]; then
  echo "Usage: X509_CHART_VERSION=4.1.0 ./upgrade.sh"
  exit 1
fi
echo "Using chart version ${X509_CHART_VERSION}"

rm -rf /tmp/x509-certificate-exporter
helm pull enix/x509-certificate-exporter --version "${X509_CHART_VERSION}" --untar --untardir /tmp
echo "Pulled helm chart ${X509_CHART_VERSION}"

helm lint /tmp/x509-certificate-exporter --values MAINTENANCE.values.yaml
echo "Helm lint done"

helm template x509-certificate-exporter /tmp/x509-certificate-exporter \
  --namespace monitoring \
  --values MAINTENANCE.values.yaml > deploy.yaml
echo "Built chart template in deploy.yaml"

mkdir -p config
wget -q "https://raw.githubusercontent.com/enix/x509-certificate-exporter/refs/tags/v${X509_CHART_VERSION}/chart/grafana-dashboards/x509-certificate-exporter.json" \
  -O config/x509-certificate-exporter.json
echo "Downloaded Grafana dashboard in config/x509-certificate-exporter.json"

yq -i '
  with(select(.kind == "PrometheusRule") | .metadata.labels;
    . = {"app": "x509-certificate-exporter", "prometheus": "k8s", "role": "alert-rules"}
  ),
  with(select(.kind != "PrometheusRule") | .metadata.labels;
    . = {"app": "x509-certificate-exporter"}
  )
' deploy.yaml
yq -i 'with(select(.spec.template.metadata.labels) | .spec.template.metadata.labels; . = {"app": "x509-certificate-exporter"})' deploy.yaml
yq -i 'with(select(.spec.selector.matchLabels) | .spec.selector.matchLabels; . = {"app": "x509-certificate-exporter"})' deploy.yaml
yq -i 'with(select(.kind == "Service") | .spec.selector; . = {"app": "x509-certificate-exporter"})' deploy.yaml
echo "Patched manifests in deploy.yaml"

if [[ "${X509_CHART_VERSION}" == "4.1.0" ]]; then
  ./patch_4.1.0.sh
fi

mise run add-license

#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

echo "Patching broken X509ExporterReadErrors alert with SourceErrors from chart v4.2.0-rc.1..."

rm -rf /tmp/x509-certificate-exporter
helm pull enix/x509-certificate-exporter --version 4.2.0-rc.1 --untar --untardir /tmp
echo "Pulled helm chart 4.2.0-rc.1"

helm template x509-certificate-exporter /tmp/x509-certificate-exporter \
  --namespace monitoring \
  --values MAINTENANCE.values.yaml > /tmp/x509-certificate-exporter/deploy.yaml
echo "Built chart template in /tmp/x509-certificate-exporter/deploy.yaml"

wget -q "https://raw.githubusercontent.com/enix/x509-certificate-exporter/refs/tags/v4.2.0-rc.1/chart/grafana-dashboards/x509-certificate-exporter.json" \
  -O config/x509-certificate-exporter.json
echo "Downloaded Grafana dashboard in config/x509-certificate-exporter.json"

yq 'select(.kind == "PrometheusRule").spec.groups[].rules | map(select(.alert == "SourceErrors" or .alert == "SourceErrorsSustained"))' \
  /tmp/x509-certificate-exporter/deploy.yaml | sed '/^#/d' > /tmp/x509-certificate-exporter/patch-alerts.yaml
yq -i 'select(.kind == "PrometheusRule").spec.groups[].rules |= map(select(.alert != "X509ExporterReadErrors"))' deploy.yaml
yq -i 'select(.kind == "PrometheusRule").spec.groups[].rules += load("/tmp/x509-certificate-exporter/patch-alerts.yaml")' deploy.yaml
echo "Rules patched"

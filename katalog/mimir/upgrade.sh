#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${MIMIR_CHART_VERSION:-}" ]; then
  echo "Usage: MIMIR_CHART_VERSION=6.0.6 ./upgrade.sh"
  exit 1
fi
echo "Using chart version ${MIMIR_CHART_VERSION}"

rm -rf /tmp/mimir-distributed
helm pull grafana/mimir-distributed --version "${MIMIR_CHART_VERSION}" --untar --untardir /tmp
echo "Downloaded chart with version $MIMIR_CHART_VERSION in /tmp/mimir-distributed"

helm lint /tmp/mimir-distributed --values MAINTENANCE.values.yaml
echo "Helm lint done"

MIMIR_TAG=$(yq '.appVersion' /tmp/mimir-distributed/Chart.yaml)
MEMCACHED_TAG=$(yq '.memcached.image.tag' /tmp/mimir-distributed/values.yaml)
MEMCACHED_EXPORTER_TAG=$(yq '.memcachedExporter.image.tag' /tmp/mimir-distributed/values.yaml)
NGINX_TAG=$(yq '.gateway.nginx.image.tag' /tmp/mimir-distributed/values.yaml)
echo "Found latest image tags: mimir=$MIMIR_TAG memcached=$MEMCACHED_TAG memcachedExporter=$MEMCACHED_EXPORTER_TAG nginx=$NGINX_TAG"

yq -i ".image.tag = \"$MIMIR_TAG\"" MAINTENANCE.values.yaml
yq -i ".memcached.image.tag = \"$MEMCACHED_TAG\"" MAINTENANCE.values.yaml
yq -i ".memcachedExporter.image.tag = \"$MEMCACHED_EXPORTER_TAG\"" MAINTENANCE.values.yaml
yq -i ".gateway.nginx.image.tag = \"$NGINX_TAG\"" MAINTENANCE.values.yaml
echo "Updated image tags in MAINTENANCE.values.yaml"

helm template mimir-distributed /tmp/mimir-distributed --no-hooks -n monitoring --values MAINTENANCE.values.yaml > deploy.yaml
echo "Built chart template in deploy.yaml file"

cp /tmp/mimir-distributed/mixins/dashboards/*.json dashboards
rm dashboards/mimir-alertmanager.json
rm dashboards/mimir-alertmanager-resources.json
rm dashboards/mimir-overrides.json
rm dashboards/mimir-ruler.json
rm dashboards/mimir-remote-ruler-reads.json
rm dashboards/mimir-remote-ruler-reads-resources.json
rm dashboards/mimir-remote-ruler-reads-networking.json
rm dashboards/rollout-operator.json
rm dashboards/mimir-rollout-progress.json
echo "Copied dashboards templates"

helm template mimir-distributed /tmp/mimir-distributed \
  --set metaMonitoring.prometheusRule.enabled=true \
  --set metaMonitoring.prometheusRule.mimirAlerts=true \
  --set metaMonitoring.prometheusRule.mimirRules=true \
  --show-only templates/metamonitoring/mixin-alerts.yaml \
  --show-only templates/metamonitoring/prometheusrule.yaml \
  --show-only templates/metamonitoring/recording-rules.yaml \
  -n monitoring --values MAINTENANCE.values.yaml > prometheusRules.yaml
echo "Built Prometheus chart template in prometheusRule.yaml file"

mise run add-license

#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

# --- Rules ---
GROUPS_FILE=$(mktemp -p /tmp)
wget -q "https://raw.githubusercontent.com/samber/awesome-prometheus-alerts/master/dist/rules/haproxy/embedded-exporter-v2.yml" -O "${GROUPS_FILE}"
echo "Downloaded rules from upstream"

yq -i '.groups[].rules |= map(select(.alert != "HaproxyHttpSlowingDown"))' "${GROUPS_FILE}"
echo "Filtered out HaproxyHttpSlowingDown rule"

yq -i ".spec.groups = load(\"$GROUPS_FILE\").groups" rules/haproxy-rules.yaml
rm -f "$GROUPS_FILE"
echo "Prometheus rule updated"

# --- Dashboard ---
LATEST_REVISION=$(curl -sf "https://grafana.com/api/dashboards/12693" | jq -r '.revision')
echo "Found latest dashboard revision ${LATEST_REVISION}"

DASHBOARD_FILE=$(mktemp -p /tmp)
wget -q "https://grafana.com/api/dashboards/12693/revisions/${LATEST_REVISION}/download" -O "${DASHBOARD_FILE}"

SED_FILE=$(mktemp -p /tmp)
sed 's/DS_PROMETHEUS/datasource/g' "${DASHBOARD_FILE}" > "${SED_FILE}"

JQ_FILE=$(mktemp -p /tmp)
jq '
  .templating.list |= map(
    if .name == "code" then
      .query.query = "label_values({__name__=~\"haproxy_.*_http_responses_total\", instance=\"$host\"}, code)"
    else . end
  )
' "${SED_FILE}" > "${JQ_FILE}"

rm -f dashboards/*.json
mv "${JQ_FILE}" "dashboards/12693_rev${LATEST_REVISION}.json"
rm $DASHBOARD_FILE $SED_FILE

yq -i ".configMapGenerator[0].files[0] = \"12693_rev${LATEST_REVISION}.json\"" dashboards/kustomization.yaml
echo "Downloaded and patched dashboards/12693_rev${LATEST_REVISION}.json"

mise add-license

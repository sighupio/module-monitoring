#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ -z "${RULES_VERSION:-}" ]; then
  echo "Usage: RULES_VERSION=2026-04-10.1 DASHBOARD_VERSION=14 ./upgrade.sh"
  exit 1
fi
echo "Using rules version ${RULES_VERSION}"

if [ -z "${DASHBOARD_VERSION:-}" ]; then
  echo "Usage: RULES_VERSION=2026-04-10.1 DASHBOARD_VERSION=14 ./upgrade.sh"
  exit 1
fi
echo "Using dashboard version ${DASHBOARD_VERSION}"

# --- Rules ---
GROUPS_FILE=$(mktemp -p /tmp)
wget -q "https://raw.githubusercontent.com/samber/awesome-prometheus-alerts/refs/tags/${RULES_VERSION}/dist/rules/haproxy/embedded-exporter-v2.yml" -O "${GROUPS_FILE}"
echo "Downloaded rules from upstream"

yq -i '.groups[].rules |= map(select(.alert != "HaproxyHttpSlowingDown"))' "${GROUPS_FILE}"
echo "Filtered out HaproxyHttpSlowingDown rule"

yq -i ".spec.groups = load(\"$GROUPS_FILE\").groups" rules/haproxy-rules.yaml
rm -f "$GROUPS_FILE"
echo "Prometheus rule updated"

# --- Dashboard ---
DASHBOARD_FILE=$(mktemp -p /tmp)
wget -q "https://grafana.com/api/dashboards/12693/revisions/${DASHBOARD_VERSION}/download" -O "${DASHBOARD_FILE}"

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
mv "${JQ_FILE}" "dashboards/12693_rev${DASHBOARD_VERSION}.json"
rm $DASHBOARD_FILE $SED_FILE

yq -i ".configMapGenerator[0].files[0] = \"12693_rev${DASHBOARD_VERSION}.json\"" dashboards/kustomization.yaml
echo "Downloaded and patched dashboards/12693_rev${DASHBOARD_VERSION}.json"

mise add-license

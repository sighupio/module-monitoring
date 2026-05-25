#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $(basename "$0") <dashboard.json>" >&2
  exit 1
fi

FILE="$1"

tmp=$(mktemp -p /tmp)
sed 's/DS_PROMETHEUS/datasource/g' "$FILE" > "$tmp" && mv "$tmp" "$FILE"

tmp=$(mktemp -p /tmp)
jq '
  .templating.list |= map(
    if .name == "code" then
      .query.query = "label_values({__name__=~\"haproxy_.*_http_responses_total\", instance=\"$host\"}, code)"
    else . end
  )
' "$FILE" > "$tmp" && mv "$tmp" "$FILE"

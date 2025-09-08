#!/usr/bin/env bash
# Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


# set -x
set -e
set -u
set -o pipefail

# Check prometheus rules
grep -ril "kind: PrometheusRule" . | \
grep -v "$(basename "$0")" | \
grep -v "kustomization.yaml" | \
grep -v "crds" | \
while read -r rules_file; do
  echo "------------- CHECKING PROMETHEUS RULES IN $rules_file ---------"
  yq '.spec' "$rules_file" | promtool check rules --lint="none" /dev/stdin
done

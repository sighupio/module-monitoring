# HAproxy Package Maintenance Guide

## Upgrade

Before running the script, check available versions:

1. Check the latest Prometheus rules version: https://github.com/samber/awesome-prometheus-alerts/releases
2. Check the latest dashboard version: https://grafana.com/grafana/dashboards/12693-haproxy/

Then run the upgrade script:

```bash
mise run upgrade <rules_version> <dashboard_version>
# Example
mise run upgrade 2026-09-07.1 14
```

The script will:

1. Download Prometheus alert rules from [awesome-prometheus-alerts](https://github.com/samber/awesome-prometheus-alerts) and update `rules/haproxy-rules.yaml` (removing the `HaproxyHttpSlowingDown` alert)
2. Download the Grafana dashboard from [grafana.com](https://grafana.com/grafana/dashboards/12693-haproxy/) and apply customizations (datasource variable rename and `code` variable metric patch)
3. Run `mise add-license` to add license headers

The customizations described below are part of this package. Preserve them when updating upstream artifacts; do not overwrite them with upstream rule expressions or dashboard queries.

## Customizations

### Dashboard

1. Changed datasource variable name from `DS_PROMETHEUS` to `datasource`.
2. Scope the `host` variable to `label_values(haproxy_process_nbproc{job="prometheus"},instance)`.
3. Scope the `code` variable to `{__name__=~"haproxy_.*_http_responses_total",job="prometheus",instance="$host"}`.

### Alerts

1. Removed the `HaproxyHttpSlowingDown` alert from upstream rules.
2. Add `job="prometheus"` to every HAProxy metric selector. The `haproxy-lb` ScrapeConfig in the distribution assigns this label to the external L4 HAProxy targets. The filter prevents these generic upstream rules from evaluating HAProxy IC metrics, which use the same metric names but `haproxy-ingress*` jobs.

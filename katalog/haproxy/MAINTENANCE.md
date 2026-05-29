# HAproxy Package Maintenance Guide

## Upgrade

Run the upgrade script to update both rules and dashboard from upstream:

```bash
./upgrade.sh
```

The script will:

1. Download Prometheus alert rules from [awesome-prometheus-alerts](https://github.com/samber/awesome-prometheus-alerts) and update `rules/haproxy-rules.yaml` (removing the `HaproxyHttpSlowingDown` alert)
2. Download the latest Grafana dashboard from [grafana.com](https://grafana.com/grafana/dashboards/12693-haproxy/) and apply customizations (datasource variable rename and `code` variable metric patch)
3. Run `mise add-license` to add license headers

## Customizations

### Dashboard

1. Changed datasource variable name from `DS_PROMETHEUS` to `datasource`.
2. Changed the `code` variable metric from `haproxy_server_http_responses_total{instance="$host"}` to `{__name__=~"haproxy_.*_http_responses_total",instance="$host"}`.

### Alerts

1. Removed the `HaproxyHttpSlowingDown` alert from upstream rules.

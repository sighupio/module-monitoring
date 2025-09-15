# HAproxy Package Maintenance Guide

## Grafana Dashboard

The included Grafana dashboard has been taken from:

<https://grafana.com/grafana/dashboards/12693-haproxy-2-full//>
<https://grafana.com/api/dashboards/12693/revisions/8/download>

### Customizations

1. Changed the dashboard title from "HAproxy 2 Full" to "HAproxy"
2. Changed datasource variable name from `DS_PROMETHEUS` to `datasource`.
2. Changed the `code` variable metric from `haproxy_server_http_responses_total{instance="$host"}` to `{__name__=~"haproxy_.*_http_responses_total",instance="$host"}`.

## Alerts

The Prometheus Rules for alerts are taken from the [Awesome Prometheus Alerts](https://samber.github.io/awesome-prometheus-alerts/rules#haproxy-1) project.

In particular from here:

<https://raw.githubusercontent.com/samber/awesome-prometheus-alerts/master/dist/rules/haproxy/embedded-exporter-v2.yml>

We took the contents of the previous link and embedded it into a `PrometheusRule` object.

### Alerts Customizations

1. Commented out the `HaproxyHttpSlowingDown` alert
2. Edited the `HaproxyBackendMaxActiveSession>80%` alert to use the `haproxy_backend_current_sessions` and `haproxy_backend_limit_sessions` metrics. We also [opened a PR upstream](https://github.com/samber/awesome-prometheus-alerts/pull/475) with this fix.

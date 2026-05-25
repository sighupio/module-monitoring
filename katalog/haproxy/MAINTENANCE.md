# HAproxy Package Maintenance Guide

## Grafana Dashboard

The included Grafana dashboard has been taken from:

<https://grafana.com/grafana/dashboards/12693-haproxy/>
<https://grafana.com/api/dashboards/12693/revisions/14/download>

### Customizations

1. Changed datasource variable name from `DS_PROMETHEUS` to `datasource`.
2. Changed the `code` variable metric from `haproxy_server_http_responses_total{instance="$host"}` to `{__name__=~"haproxy_.*_http_responses_total",instance="$host"}`.

Both customizations are applied by running:

```bash
./dashboards/patch.sh dashboards/<dashboard>.json
```

## Alerts

The Prometheus Rules for alerts are taken from the [Awesome Prometheus Alerts](https://samber.github.io/awesome-prometheus-alerts/rules#haproxy-1) project.

In particular from here:

<https://raw.githubusercontent.com/samber/awesome-prometheus-alerts/master/dist/rules/haproxy/embedded-exporter-v2.yml>

We took the contents of the previous link and embedded it into a `PrometheusRule` object.

### Alerts Customizations

1. Commented out the `HaproxyHttpSlowingDown` alert
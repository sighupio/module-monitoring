# HAproxy Package

This package provides a Grafana Dashboard and a set of alert rules for the prometheus exporter built in HAproxy v2 (and not the `haproxy_exporter`).

To use this package to monitor an HAproxy battery *outside* the cluster, you must:

1. Check that your haproxy has been built with the built-in prometheus exporter enabled:

   ```bash
   haproxy -vvv | grep prometheus
   ```

2. Enable a frontend on HAproxy that exposes the metrics:

   ```haproxyconfig
   frontend prometheus
     bind :8405
     mode http
     http-request use-service prometheus-exporter
     no log
   ```

3. Create a `ScrapeConfig` object to make Prometheus scrape the metrics from the HAproxy hosts:

   ```yaml
   apiVersion: monitoring.coreos.com/v1alpha1
   kind: ScrapeConfig
   metadata:
     name: haproxy-lb
     namespace: monitoring
     labels:
       prometheus: k8s
   spec:
     staticConfigs:
       - labels:
           job: prometheus
         targets:
           - haproxy01.mydomain:8405
           - haproxy02.mydomain:8405
   ```

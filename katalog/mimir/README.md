# Mimir

<!-- <SD-DOCS> -->

Mimir is an open source, horizontally scalable, highly available, multi-tenant TSDB for long-term storage for Prometheus.

## Requirements

- Kubernetes >= `1.29.0`
- Kustomize = `5.6.0`
- [prometheus-operator from SD monitoring module][prometheus-operator]
- [grafana from SD monitoring module][grafana]
- [minio-ha](../minio-ha)

## Image repository

- registry.sighup.io/fury/grafana/mimir
- registry.sighup.io/fury/nginxinc/nginx-unprivileged

## Configuration

Mimir is configured with the distributed approach. We disabled some optional components: Ruler, Override exporter and Alertmanager.
By default, using this package, Prometheus operated is installed and patched to send metrics to Mimir with the remote write capability.

All the time series are ingested in the `fury` tenant. A Grafana datasource is also installed as default for prometheus type metrics to scrape from Mimir instead of Prometheus.

Also, the storage is configured by default to use the minio-ha package from the monitoring module.

## Deployment

You can deploy Mimir by running the following command in the root of
the project:

```shell
kustomize build | kubectl apply -f -
```

<!-- Links -->

[prometheus-operator]: https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/katalog/prometheus-operator
[grafana]: https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/katalog/grafana

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

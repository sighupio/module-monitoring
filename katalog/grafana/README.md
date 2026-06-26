# Grafana

<!-- <SD-DOCS> -->

## Overview

Grafana is an open-source data visualization and graph composer platform for numeric time-series data, integrated with Prometheus as its default data source. Grafana automatically loads dashboards from ConfigMaps labeled `grafana-sighup-dashboard` and data sources from ConfigMaps/Secrets labeled `grafana-sighup-datasource` across all namespaces, picked up by the bundled k8s-sidecar.

## Upstream project

This package is based on the upstream [Grafana][grafana-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.grafana` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[grafana-gh]: https://github.com/grafana/grafana
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

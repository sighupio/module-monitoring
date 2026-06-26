# Prometheus Operated

<!-- <SD-DOCS> -->

## Overview

Prometheus Operated deploys Prometheus instances via the Prometheus CRD defined by the [prometheus-operator](../prometheus-operator). Prometheus is a monitoring tool that collects metrics-based time series data and provides a functional expression language to select and aggregate time series in real time. The deployment ships a set of default Prometheus rules and alerts and is integrated with Grafana for visualization (see the [grafana](../grafana) package).

## Upstream project

This package is based on the upstream [Prometheus][prom-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.prometheus` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[prom-gh]: https://github.com/prometheus/prometheus
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

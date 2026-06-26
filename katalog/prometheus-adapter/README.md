# Prometheus Adapter

<!-- <SD-DOCS> -->

## Overview

The Prometheus Adapter provides an implementation of the Kubernetes resource metrics, custom metrics and external metrics APIs. It is suitable for use with the `autoscaling/v2` Horizontal Pod Autoscaler and can also replace the metrics server on clusters that already run Prometheus.

## Upstream project

This package is based on the upstream [prometheus-adapter][pa-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.prometheusAdapter` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[pa-gh]: https://github.com/kubernetes-sigs/prometheus-adapter
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

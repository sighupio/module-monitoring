# Mimir

<!-- <SD-DOCS> -->

## Overview

Mimir is an open-source, horizontally scalable, highly available, multi-tenant TSDB for long-term storage for Prometheus. It is deployed with a distributed approach (with Ruler, Override exporter and Alertmanager disabled), and Prometheus is patched to remote-write its metrics to Mimir. All time series are ingested in the `fury` tenant, a Grafana data source is installed to query Mimir instead of Prometheus, and by default storage is backed by the [minio-ha](../minio-ha) package.

## Upstream project

This package is based on the upstream [Grafana Mimir][mimir-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.mimir` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[mimir-gh]: https://github.com/grafana/mimir
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

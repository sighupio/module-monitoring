# MinIO HA

<!-- <SD-DOCS> -->

## Overview

MinIO is a distributed object storage system used to deploy highly available and scalable storage. This package deploys MinIO in high-availability mode as a three-Pod StatefulSet (with two PVCs per Pod) and runs an init Job to initialize the buckets and default retention. A `ServiceMonitor` is configured so its metrics are scraped by Prometheus. In the Monitoring Module it provides the default object storage backend for Mimir.

## Upstream project

This package is based on the upstream [MinIO][minio-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.minio` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[minio-gh]: https://github.com/minio/minio
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

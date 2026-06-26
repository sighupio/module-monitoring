# x509 Exporter

<!-- <SD-DOCS> -->

## Overview

The x509 exporter provides monitoring for certificates, exposing metrics about their validity and expiration so they can be scraped by Prometheus and alerted on.

## Upstream project

This package is based on the upstream [x509-certificate-exporter][x509-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.x509Exporter` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[x509-gh]: https://github.com/enix/x509-certificate-exporter
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

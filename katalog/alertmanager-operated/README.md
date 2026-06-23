# Alertmanager Operated

<!-- <SD-DOCS> -->

## Overview

Alertmanager handles alerts sent by the Prometheus server and routes them to configured receiver integrations such as email, Slack, PagerDuty, or OpsGenie. It helps you manage alerts flexibly with its grouping, inhibition and silencing features. The Prometheus deployment (see [prometheus-operated](../prometheus-operated)) is already configured to automatically discover the Alertmanager instances deployed with this package.

## Upstream project

This package is based on the upstream [Alertmanager][am-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.alertmanager` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[am-gh]: https://github.com/prometheus/alertmanager
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

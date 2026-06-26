# Prometheus Operator

<!-- <SD-DOCS> -->

## Overview

Prometheus Operator is an application-specific controller that makes it easy to deploy and manage Prometheus instances on Kubernetes. It removes the need to learn Prometheus-specific configuration to monitor services: target discovery is achieved through the `ServiceMonitor` CRD, with scrape configuration generated automatically from Kubernetes label selectors. The operator acts on the `Prometheus`, `ServiceMonitor`, `PrometheusRule` and `Alertmanager` custom resources, handling deployment, version upgrades, persistent volume claims and the discovery of Alertmanager instances.

## Upstream project

This package is based on the upstream [Prometheus Operator][prom-op-github].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`. See the [module documentation](../../README.md) to learn how the Monitoring Module is installed and configured.

<!-- Links -->

[prom-op-github]: https://github.com/prometheus-operator/prometheus-operator

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

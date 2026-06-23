# Blackbox Exporter

<!-- <SD-DOCS> -->

## Overview

The Blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC. It ships with probes for HTTP 2xx (GET and POST), IRC, POP3S, SSH and TCP connections, and its metrics are scraped by Prometheus.

## Upstream project

This package is based on the upstream [Blackbox exporter][blackbox-exporter-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.blackboxExporter` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[blackbox-exporter-gh]: https://github.com/prometheus/blackbox_exporter
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

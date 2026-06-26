# HAproxy

<!-- <SD-DOCS> -->

## Overview

This package provides a Grafana dashboard and a set of Prometheus alert rules for the Prometheus exporter built into HAproxy v2 (not the standalone `haproxy_exporter`). It is intended to monitor an HAproxy battery running outside the cluster: the HAproxy instances must be built with the built-in Prometheus exporter enabled and expose the metrics on a dedicated frontend, then a `ScrapeConfig` resource makes Prometheus scrape those targets.

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`. See the [module documentation](../../README.md) to learn how the Monitoring Module is installed and configured.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

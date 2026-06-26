# Node Exporter

<!-- <SD-DOCS> -->

## Overview

Node Exporter provides monitoring for hardware and OS metrics exposed by \*NIX kernels. It runs as a DaemonSet and exposes node-level metrics (CPU, memory, filesystem, network and more) that are scraped by Prometheus.

## Upstream project

This package is based on the upstream [Node Exporter][ne-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`. See the [module documentation](../../README.md) to learn how the Monitoring Module is installed and configured.

<!-- Links -->

[ne-gh]: https://github.com/prometheus/node_exporter

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

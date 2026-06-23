# AKS ServiceMonitor

<!-- <SD-DOCS> -->

## Overview

This package provides monitoring for the Kubernetes components `kubelet`, `coredns` and `api-server` on AKS. `api-server` and `kubelet` metrics are scraped every `30s` and `coredns` every `15s`, and it ships a set of Grafana dashboards (CoreDNS, API server, kubelet, networking and persistent volumes) for those components.

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`. See the [module documentation](../../README.md) to learn how the Monitoring Module is installed and configured.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

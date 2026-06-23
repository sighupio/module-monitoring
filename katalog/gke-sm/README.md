# GKE ServiceMonitor

<!-- <SD-DOCS> -->

## Overview

This package provides monitoring for the Kubernetes components `kubelet` and `api-server` on GKE, the managed cluster solution by GCP. Metrics are scraped every `30s`, and it ships a set of Grafana dashboards (API server, kubelet, networking and persistent volumes) for those components.

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`. See the [module documentation](../../README.md) to learn how the Monitoring Module is installed and configured.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

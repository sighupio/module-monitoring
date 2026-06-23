# kube-proxy Metrics Exporter

<!-- <SD-DOCS> -->

## Overview

kube-proxy is a critical component of any Kubernetes cluster, so it is highly recommended to gather its metrics. In some environments (especially managed clusters) it is not possible to configure kube-proxy to be reachable by Prometheus for scraping; this package solves that and additionally adds an authorization layer based on Kubernetes RBAC to the metrics exposed by kube-proxy.

## Upstream project

This package is based on the upstream [kube-rbac-proxy][krp-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`. See the [module documentation](../../README.md) to learn how the Monitoring Module is installed and configured.

<!-- Links -->

[krp-gh]: https://github.com/brancz/kube-rbac-proxy

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

# Kubeadm ServiceMonitor

<!-- <SD-DOCS> -->

## Overview

This package provides monitoring for the Kubernetes components of self-managed or on-premises clusters: `kubelet`, `coredns`, `api-server`, `kube-controller-manager`, `kube-scheduler` and `etcd`. It ships ServiceMonitors that scrape these components, a set of Grafana dashboards, and Prometheus rules and alerts for the control-plane components, CoreDNS and etcd.

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`. See the [module documentation](../../../README.md) to learn how the Monitoring Module is installed and configured.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../../LICENSE)

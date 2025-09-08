# AKS ServiceMonitor

<!-- <SD-DOCS> -->

This package provides monitoring for Kubernetes components `kubelet`, `coredns` and
`api-server` on AKS.

## Requirements

- Kubernetes >= `1.31.0`
- Kustomize = `5.6.0`
- [prometheus-operator](../prometheus-operator)

## Configuration

Fury distribution AKS ServiceMonitor has the following configuration:

- `api-server` and `kubelet` metrics are scraped with `30s` intervals
- `coredns` metrics are scraped with `15s` intervals
- Dashboards shipped:
  - `coredns`: CoreDNS >= 1.8.0
  - `api-server`: Kubernetes / API server
  - `cluster-total`: Kubernetes / Networking / Cluster
  - `kubelet`: Kubernetes / Kubelet
  - `namespace-by-pod`: Kubernetes / Networking / Namespace (Pods)
  - `namespace-by-workload`: Kubernetes / Networking / Namespace (Workload)
  - `persistent-volumes-usage`: Kubernetes / Persistent Volumes
  - `pod-total`: Kubernetes / Networking / Pod
  - `workload-total`: Kubernetes / Networking / Workload

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

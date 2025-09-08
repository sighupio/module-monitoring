# GKE ServiceMonitor

<!-- <SD-DOCS> -->

This package provides monitoring for Kubernetes components `kubelet` and
`api-server` on GKE, the managed cluster solution by GCP.

## Requirements

- Kubernetes >= `1.31.0`
- Kustomize = `5.6.0`
- [prometheus-operator](../prometheus-operator)

## Configuration

Fury distribution GKE ServiceMonitor has following configuration:

- `api-server` and `kubelet` metrics are scraped with `30s` intervals
- Dashboards shipped:
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

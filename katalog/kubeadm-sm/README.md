# Kubeadm ServiceMonitor

<!-- <SD-DOCS> -->

This package provides monitoring for the following Kubernetes components:

- kubelet
- coredns
- api-server
- kube-control-manager
- kube-scheduler
- etcd

These are components needed to deliver a functioning Kubernetes cluster. If you
want to learn more about these components please follow the official
[documentation](https://kubernetes.io/docs/concepts/overview/components/) of
Kubernetes.

> :warning: This package is guaranteed to work only on clusters created using
> [`kubeadm`](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/),
> for managed clusters please take a look at the [`aks-sm`](../aks-sm),
> [`eks-sm`](../eks-sm) and [`gke-sm`](../gke-sm) packages.

## Requirements

- Kubernetes >= `1.31.0`
- Kustomize = `5.6.0`
- [prometheus-operator](../prometheus-operator)

## Configuration

Prometheus scrapes Kubernetes component metrics on port `metrics` with following
intervals:

- kube-control-manager: `30s`
- coredns: `15s`
- etcd: `15s`
- api-server: `30s`
- kubelet: `30s`
- kube-scheduler: `30s`
- Dashboards shipped:
  - `coredns`: CoreDNS < 1.7.0
  - `api-server`: Kubernetes / API server
  - `cluster-total`: Kubernetes / Networking / Cluster
  - `kubelet`: Kubernetes / Kubelet
  - `namespace-by-pod`: Kubernetes / Networking / Namespace (Pods)
  - `namespace-by-workload`: Kubernetes / Networking / Namespace (Workload)
  - `persistent-volumes-usage`: Kubernetes / Persistent Volumes
  - `pod-total`: Kubernetes / Networking / Pod
  - `workload-total`: Kubernetes / Networking / Workload
  - `controller-manager`: Kubernetes / Controller Manager
  - `etcd`: Etcd
  - `scheduler`: Kubernetes / Scheduler

## Alerts

The followings alerts are already defined for this package.

### kubernetes-absent-kubeadm

| Parameter                       | Description                                                                                                               | Severity | Interval |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| KubeControllerManagerDown       | This alert fires if Prometheus target discovery was not able to reach the kube-controller-manager in the last 15 minutes. | critical |   15m    |
| KubeSchedulerDown               | This alert fires if Prometheus target discovery was not able to reach the kube-scheduler in the last 15 minutes.          | critical |   15m    |
| KubeClientCertificateExpiration | This alert fires when the Kubernetes API client certificate is expiring in less than 30 days.                             | warning  |          |
| KubeClientCertificateExpiration | This alert fires when the Kubernetes API client certificate is expiring in less than 7 days.                              | critical |          |

### coredns

| Parameter                    | Description                                                                                                      | Severity | Interval |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| CoreDNSPanic                 | This alert fires if CoreDNS total panic count increased by at least 1 in the last 10 minutes.                    | warning  |          |
| CoreDNSRequestsLatency       | This alert fires if CoreDNS 99th percentile requests latency was higher than 100ms in the last 10 minutes.       | warning  |   10m    |
| CoreDNSHealthRequestsLatency | This alert fires if CoreDNS 99th percentile health requests latency was higher than 10ms in the last 10 minutes. | warning  |   10m    |
| CoreDNSProxyRequestsLatency  | This alert fires if CoreDNS 99th percentile proxy requests latency was higher than 500ms in the last 10 minutes. | warning  |   10m    |

### etcd3

| Parameter                       | Description                                                                                                  | Severity | Interval |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------ | -------- | :------: |
| EtcdInsufficientMembers         | This alert fires if less than half of Etcd cluster members were online in the last 3 minutes.                | critical |    3m    |
| EtcdNoLeader                    | This alert fires if the Etcd cluster had no leader in the last minute.                                       | critical |    1m    |
| EtcdHighNumberOfLeaderChanges   | This alert fires if the Etcd cluster changed leader more than 3 times in the last hour.                      | warning  |          |
| EtcdHighNumberOfFailedProposals | This alert fires if there were more than 5 proposal failure in the last hour.                                | warning  |          |
| EtcdHighFsyncDurations          | This alert fires if the WAL fsync 99th percentile latency was higher than 0.5s in the last 10 minutes.       | warning  |   10m    |
| EtcdHighCommitDurations         | This alert fires if the backend commit 99th percentile latency was higher than 0.25s in the last 10 minutes. | warning  |   10m    |

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

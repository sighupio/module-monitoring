<!-- markdownlint-disable MD033 -->
<h1 align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/black-logo.png">
  <img alt="Shows a black logo in light color mode and a white one in dark color mode." src="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
</picture><br/>
  Monitoring Module
</h1>
<!-- markdownlint-enable MD033 -->

![Release](https://img.shields.io/badge/Latest%20Release-v4.2.0-blue)
![License](https://img.shields.io/github/license/sighupio/module-monitoring?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <SD-DOCS> -->

**Monitoring Module** provides a fully-fledged monitoring stack for [SIGHUP Distribution (SD)][kfd-repo]. This module extends and improves upon the [Kube-Prometheus][kube-prometheus-link] project.

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

This module gives you full control and visibility over your cluster operations: metrics from the cluster and your applications are collected by [Prometheus][prometheus-link] and visualized through [Grafana][grafana-link]. The stack is built around the `prometheus-operator`, which manages Prometheus, [Alertmanager][alertmanager-link] and `ServiceMonitor` resources as Kubernetes-native controllers.

Provider-specific `ServiceMonitors` (EKS, AKS, GKE and on-premises/self-managed clusters) are selected and deployed automatically based on your cluster, so the right Kubernetes components metrics are collected without manual configuration. Most components run in the `monitoring` namespace, except those that require permissions that force them into `kube-system`.

## Packages

The following packages are included in Monitoring Module:

| Package                                                | Version  | Description                                                                                                               |
| ------------------------------------------------------ | -------- | ------------------------------------------------------------------------------------------------------------------------- |
| [prometheus-operator](katalog/prometheus-operator)     | `0.89.0` | Operator to deploy and manage Prometheus and related resources                                                            |
| [prometheus-operated](katalog/prometheus-operated)     | `3.10.0` | Prometheus instance deployed with Prometheus Operator's CRD                                                               |
| [alertmanager-operated](katalog/alertmanager-operated) | `0.31.1` | Alertmanager instance deployed with Prometheus Operator's CRD                                                             |
| [blackbox-exporter](katalog/blackbox-exporter)         | `0.28.0` | Prometheus exporter that allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.                  |
| [grafana](katalog/grafana)                             | `12.4.1` | Grafana deployment to query and visualize metrics collected by Prometheus                                                 |
| [kube-proxy-metrics](katalog/kube-proxy-metrics)       | `0.22.0` | RBAC proxy to securely expose kube-proxy metrics                                                                          |
| [kube-state-metrics](katalog/kube-state-metrics)       | `2.18.0` | Service that generates metrics from Kubernetes API objects                                                                |
| [node-exporter](katalog/node-exporter)                 | `1.10.2` | Prometheus exporter for hardware and OS metrics exposed by \*NIX kernels                                                  |
| [prometheus-adapter](katalog/prometheus-adapter)       | `0.12.0` | Kubernetes resource metrics, custom metrics, and external metrics APIs implementation.                                    |
| [x509-exporter](katalog/x509-exporter)                 | `4.1.0`  | Provides monitoring for certificates                                                                                      |
| [mimir](katalog/mimir)                                 | `3.0.4`  | Mimir is an open source, horizontally scalable, highly available, multi-tenant TSDB for long-term storage for Prometheus. |
| [haproxy](katalog/haproxy)                             | `N.A.`   | Grafana dashboards and Prometheus rules (alerts) for HAproxy.                                                             |

The module also ships the provider-specific ServiceMonitor packages (`eks-sm`, `aks-sm`, `gke-sm`, `kubeadm-sm`), which are selected and deployed automatically based on your cluster's provider.

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.32.x`           | :white_check_mark: | No known issues |
| `1.33.x`           | :white_check_mark: | No known issues |
| `1.34.x`           | :white_check_mark: | No known issues |
| `1.35.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

**Monitoring Module** is part of SIGHUP Distribution (SD) and is deployed automatically by [`furyctl`][furyctl-repo] when you create or update a cluster. You don't need to download, vendor or install its packages manually.

### Configuration

You choose whether and how to deploy the monitoring stack under `spec.distribution.modules.monitoring` in your `furyctl.yaml`: the `type` field selects the flavor (`prometheus`, `prometheusAgent` or `mimir`), or disables the module entirely with `none`. The other fields let you customize the individual packages; the ones you leave out are deployed with sensible defaults.

```yaml
apiVersion: kfd.sighup.io/v1alpha2
kind: KFDDistribution
spec:
  distribution:
    modules:
      monitoring:
        # Monitoring stack flavor: none, prometheus, prometheusAgent or mimir
        type: prometheus
        prometheus:
          retentionTime: 30d
          retentionSize: 120GB
          storageSize: 150Gi
        alertmanager:
          installDefaultRules: true
          slackWebhookUrl: https://hooks.slack.com/services/XXXXXX
```

To keep metrics for the long term, set `type: mimir` and configure the `mimir` block with its storage backend (`minio` for an in-cluster MinIO, or `externalEndpoint` for an external S3-compatible bucket):

```yaml
apiVersion: kfd.sighup.io/v1alpha2
kind: KFDDistribution
spec:
  distribution:
    modules:
      monitoring:
        type: mimir
        mimir:
          retentionTime: 30d
          backend: minio
```

See the configuration reference for your cluster kind for the full list of available options: [EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd] or [OnPremises][schema-reference-onprem].

To install SD from scratch, follow the [Getting started][getting-started] guide.

<!-- Links -->

[kfd-repo]: https://github.com/sighupio/distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kfd-docs]: https://docs.sighup.io/docs/distribution/
[kube-prometheus-link]: https://github.com/prometheus-operator/kube-prometheus
[prometheus-link]: https://github.com/prometheus/prometheus
[alertmanager-link]: https://github.com/prometheus/alertmanager
[grafana-link]: https://grafana.com/
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring
[getting-started]: https://docs.sighup.io/docs/getting-started/
[compatibility-matrix]: https://github.com/sighupio/module-monitoring/blob/main/docs/COMPATIBILITY_MATRIX.md

<!-- </SD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](https://github.com/sighupio/distribution/blob/main/docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/module-monitoring/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE).

<!-- </FOOTER> -->

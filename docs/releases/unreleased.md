# Monitoring Module Release v4.3.0

Welcome to the latest release of the `monitoring` core module of the [`SIGHUP Distribution`](https://github.com/sighupio/distribution), maintained by team SIGHUP by ReeVo.

This release adds support for Kubernetes 1.36 and updates all core components to their latest versions.

## Component Images 🚢

| Component             | Supported Version                                                                                                                       | Previous Version             |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------|------------------------------|
| `alertmanager`        | [`v0.31.1`](https://github.com/prometheus/alertmanager/releases/tag/v0.31.1)                                                            | v0.28.1                      |
| `blackbox-exporter`   | [`v0.28.0`](https://github.com/prometheus/blackbox_exporter/releases/tag/v0.28.0)                                                       | v0.27.0                      |
| `grafana`             | [`v12.4.1`](https://github.com/grafana/grafana/releases/tag/v12.4.1)                                                                    | v12.1.0                      |
| `kube-rbac-proxy`     | [`v0.21.0`](https://github.com/brancz/kube-rbac-proxy/releases/tag/v0.21.0)                                                             | v0.19.1                      |
| `kube-state-metrics`  | [`v2.18.0`](https://github.com/kubernetes/kube-state-metrics/releases/tag/v2.18.0)                                                      | v2.16.0                      |
| `node-exporter`       | [`v1.10.2`](https://github.com/prometheus/node_exporter/releases/tag/v1.10.2)                                                           | v1.9.1                       |
| `prometheus-adapter`  | [`v0.12.0`](https://github.com/kubernetes-sigs/prometheus-adapter/releases/tag/v0.12.0)                                                 | No update                    |
| `prometheus-operator` | [`v0.89.0`](https://github.com/prometheus-operator/prometheus-operator/releases/tag/v0.89.0)                                            | v0.85.0                      |
| `prometheus-operated` | [`v3.10.0`](https://github.com/prometheus/prometheus/releases/tag/v3.10.0)                                                              | v3.5.0                       |
| `x509-exporter`       | [`v4.1.0`](https://github.com/enix/x509-certificate-exporter/releases/tag/v4.1.0)                                                       | v3.19.1                      |
| `mimir`               | [`v3.0.4`](https://github.com/grafana/mimir/releases/tag/mimir-3.0.4)                                                                   | v2.17.0                      |
| `minio`               | [`RELEASE.2026-05-20T23-44-52Z`](https://github.com/chainguard-forks/minio/releases/tag/RELEASE.2026-05-20T23-44-52Z) (chainguard-fork) | RELEASE.2025-09-07T16-13-09Z |
| `mc`                  | [`RELEASE.2025-08-13T08-35-41Z`](https://github.com/minio/mc/releases/tag/RELEASE.2025-08-13T08-35-41Z)                                 | No update                    |

> Please refer to the individual release notes to get detailed info on the releases.

## Update Guide 🦮

The furyctl tool now manages Module installations and upgrades. The instructions below are left for reference when using the legacy version of furyctl.

### Process

To upgrade the module run:

```bash
kustomize build <your-project-path> | kubectl apply -f - --server-side
```

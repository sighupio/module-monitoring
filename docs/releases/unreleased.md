# Monitoring Module Release v4.3.0

Welcome to the latest release of the `monitoring` core module of the [`SIGHUP Distribution`](https://github.com/sighupio/distribution), maintained by team SIGHUP by ReeVo.

This release adds support for Kubernetes 1.36, updates all core components to their latest versions, and officially drops support for Kubernetes versions 1.32.

## Component Images 🚢

| Component             | Supported Version                                                                                                                       | Previous Version |
|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------|------------------|
| `alertmanager`        | [`v0.33.0`](https://github.com/prometheus/alertmanager/releases/tag/v0.33.0)                                                            | v0.31.1          |
| `blackbox-exporter`   | [`v0.28.0`](https://github.com/prometheus/blackbox_exporter/releases/tag/v0.28.0)                                                       | No update        |
| `grafana`             | [`v13.0.2`](https://github.com/grafana/grafana/releases/tag/v13.0.2)                                                                    | v12.4.1          |
| `kube-rbac-proxy`     | [`v0.22.0`](https://github.com/brancz/kube-rbac-proxy/releases/tag/v0.22.0)                                                             | v0.21.0          |
| `kube-state-metrics`  | [`v2.18.0`](https://github.com/kubernetes/kube-state-metrics/releases/tag/v2.18.0)                                                      | No update        |
| `node-exporter`       | [`v1.10.2`](https://github.com/prometheus/node_exporter/releases/tag/v1.10.2)                                                           | No update        |
| `prometheus-adapter`  | [`v0.12.0`](https://github.com/kubernetes-sigs/prometheus-adapter/releases/tag/v0.12.0)                                                 | No update        |
| `prometheus-operator` | [`v0.89.0`](https://github.com/prometheus-operator/prometheus-operator/releases/tag/v0.89.0)                                            | No update        |
| `prometheus-operated` | [`v3.10.0`](https://github.com/prometheus/prometheus/releases/tag/v3.10.0)                                                              | No update        |
| `x509-exporter`       | [`v4.1.0`](https://github.com/enix/x509-certificate-exporter/releases/tag/v4.1.0)                                                       | No update        |
| `mimir`               | [`v3.2.0`](https://github.com/grafana/mimir/releases/tag/mimir-3.2.0)                                                                   | v3.0.4           |
| `minio`               | [`RELEASE.2026-05-20T23-44-52Z`](https://github.com/chainguard-forks/minio/releases/tag/RELEASE.2026-05-20T23-44-52Z) (chainguard-fork) | No update        |
| `mc`                  | [`RELEASE.2025-08-13T08-35-41Z`](https://github.com/minio/mc/releases/tag/RELEASE.2025-08-13T08-35-41Z)                                 | No update        |

> Please refer to the individual release notes to get detailed info on the releases.

## New features 🎉

### Mimir

The following improvements are active by default with the module's configuration:

- **Query sharding enabled by default**: shardable range queries are automatically split across queriers for better parallelism.
- **Remote query execution enabled by default**: the query-frontend plans queries and distributes portions of the plan to queriers through the Mimir Query Engine (MQE), including subset-selector elimination and subquery spin-off.
- Several MQE query-path optimizations that reduce CPU and memory consumption.


## Breaking Changes 💔

- **Dropped support for Kubernetes 1.32**: Clusters running Kubernetes `1.32` or older are no longer supported and should be upgraded before upgrading to this module version.

## Update Guide 🦮

> [!WARNING]
> Mimir is upgraded directly from `v3.0.4` to `v3.2.0` (two minor versions). Mimir 3.2 enables remote query execution by default, which requires queriers on at least Mimir 3.1. During the rolling upgrade, there may be a short window in which a new query-frontend sends query plans to queriers that have not been upgraded yet, causing transient query errors. This resolves automatically once all queriers are running the new version.

The furyctl tool now manages Module installations and upgrades. The instructions below are left for reference when using the legacy version of furyctl.

### Process

To upgrade the module run:

```bash
kustomize build <your-project-path> | kubectl apply -f - --server-side
```

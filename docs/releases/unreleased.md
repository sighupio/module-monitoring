# Monitoring Module Release vTBD

Welcome to the latest release of the `monitoring` core module of the [`SIGHUP Distribution`](https://github.com/sighupio/distribution), maintained by team SIGHUP by ReeVo.

## New features 🎉

### kube-proxy-metrics

The `instance` label of kube-proxy metrics now contains the node name instead of `<node-ip>:18443`, making it more readable and aligned with node-exporter metrics. Custom alerts, recording rules or dashboards filtering kube-proxy metrics by `instance` need to be updated.

## Update Guide 🦮

The furyctl tool now manages Module installations and upgrades. The instructions below are left for reference when using the legacy version of furyctl.

### Process

To upgrade the module run:

```bash
kustomize build <your-project-path> | kubectl apply -f - --server-side
```

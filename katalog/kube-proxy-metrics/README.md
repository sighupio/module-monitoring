# kube-proxy Metrics Exporter

<!-- <SD-DOCS> -->

kube-proxy is a critical piece of any Kubernetes cluster, therefore it is highly
recommended to gather its metrics. Sometimes (especially in managed clusters) it
is not possible to configure kube-proxy to be reachable by Prometheus for
metrics scraping, this is why this package exists. Furthermore, this package
also adds an authorization layer based on Kubernetes RBAC to the metrics exposed
by kube-proxy.

## Requirements

- Kubernetes >= `1.29.0`
- Kustomize = `5.6.0`
- [prometheus-operator](../prometheus-operator)

## Image repository and tag

- kube-rbac-proxy image: `registry.sighup.io/fury/brancz/kube-rbac-proxy:v0.19.1`
- kube-rbac-proxy repository: [kube-rbac-proxy on Github][krp-gh]

## Configuration

Fury distribution kube-proxy-metrics is deployed with the following configuration:

- Resource limits are `20m` for CPU and `40Mi` for memory
- Listens on port `18443`
- Metrics are scraped by Prometheus with `15s` intervals
- Requires `hostNetwork: true` and `hostPID: true`
- Runs as non-root user.

## Deployment

You can deploy kube-proxy-metrics by running the following command:

```shell
kustomize build | kubectl apply -f -
```

<!-- Links -->

[krp-gh]: https://quay.io/repository/brancz/kube-rbac-proxy

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

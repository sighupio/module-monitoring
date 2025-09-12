# Kube State Metrics

<!-- <SD-DOCS> -->

This package provides kube-state-metrics service which listens to Kubernetes API
server and generates metrics about the state of Kubernetes objects like
Deployments, Nodes, or Pods.

From kube-state-metrics
[repository](https://github.com/kubernetes/kube-state-metrics):

> That kube-state-metrics is about generating metrics from Kubernetes API
> objects without modification. This ensures, that features provided by
> kube-state-metrics have the same grade of stability as the Kubernetes API
> objects themselves. In turn, this means, that kube-state-metrics in certain
> situations may not show the same values as kubectl, as kubectl applies
> certain heuristics to display comprehensible messages. kube-state-metrics
> exposes raw data unmodified from the Kubernetes API, this way users have all
> the data they require and perform heuristics as they see fit.

## Requirements

- Kubernetes >= `1.31.0`
- Kustomize = `5.6.0`
- [prometheus-operator](../prometheus-operator)

## Image repository and tag

- kube-state-metrics image: `registry.sighup.io/fury/kube-state-metrics/kube-state-metrics:v2.16.0`
- kube-state-metrics repository: [kube-state-metrics on GH][ksm-gh]
- kube-rbac-proxy image: `registry.sighup.io/fury/brancz/kube-rbac-proxy:v0.19.1`
- kube-rbac-proxy repository: [kube-rbac-proxy on Github][krp-gh]

## Configuration

Fury distribution kube-state-metrics is deployed with the following configuration:

- Resource limits are `100m` for CPU and `150Mi` for memory
- Listens on port `8080`
- Exposes kubernetes-related metrics on port `8080` and metrics about itself on
  port `8081`
- Metrics are scraped by Prometheus with `30s` intervals

## Deployment

You can deploy kube-state-metrics by running the following command:

```shell
kustomize build | kubectl apply -f -
```

<!-- Links -->

[ksm-gh]: https://github.com/kubernetes/kube-state-metrics
[krp-gh]: https://quay.io/repository/brancz/kube-rbac-proxy

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

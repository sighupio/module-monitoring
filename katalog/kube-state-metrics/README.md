# Kube State Metrics

<!-- <SD-DOCS> -->

## Overview

kube-state-metrics listens to the Kubernetes API server and generates metrics about the state of Kubernetes objects such as Deployments, Nodes, and Pods. It exposes raw, unmodified data from the Kubernetes API, so users can build their own heuristics on top of it.

## Upstream project

This package is based on the upstream [kube-state-metrics][ksm-gh].

## Deployment

This package is deployed as part of **Monitoring Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.monitoring.kubeStateMetrics` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[ksm-gh]: https://github.com/kubernetes/kube-state-metrics
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulesmonitoring
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulesmonitoring
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulesmonitoring

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

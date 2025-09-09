# Prometheus Operated

<!-- <SD-DOCS> -->

Prometheus Operated deploys Prometheus instances via Prometheus CRD as defined
by [Prometheus Operator](../prometheus-operator).

Prometheus is a monitoring tool to collect metrics-based time series data and
provides a functional expression language that lets the user select and
aggregate time-series data in real-time. Prometheus's expression browser makes it
possible to analyze queried data as a graph or view it as tabular data, but it's
also possible to integrate it with third-party time-series analytics tools like
Grafana. Grafana integration is provided in Fury monitoring katalog, please see
[Grafana](../grafana) package's documentation.

## Requirements

- Kubernetes >= `1.31.0`
- Kustomize = `5.6.0`
- [prometheus-operator](../prometheus-operator)

## Image repository and tag

- Prometheus image: `registry.sighup.io/prometheus/prometheus:v3.5.0`
- Prometheus repository: [Prometheus on Github][prom-gh]
- Prometheus documentation: [Prometheus documentation site][prom-doc]

## Configuration

Fury distribution Prometheus is deployed with the following configuration:

- Replica number: `1`
- Retention for `30` days
- Retention Storage `120 Gb` (80% of the default 150)
- Requires `150Gi` storage (with default storage type of Provider)
- Listens on port `9090`
- Alertmanager endpoint set to `alertmanager-main`

## Deployment

You can deploy Prometheus Operated by running the following command:

```shell
kustomize build | kubectl apply -f -
```

To learn how to customize it for your needs please see the
[examples](../../examples/serviceMonitor) folder.

### Accessing Prometheus UI

You can access to Prometheus expression browser by port-forwarding on port 9090:

```shell
kubectl port-forward svc/prometheus-k8s 9090:9090 --namespace monitoring
```

Now if you go to <http://127.0.0.1:9090> on your browser you can execute queries
and visualize query results.

### Service Monitoring

Target discovery is achieved via ServiceMonitor CRD, to learn more about
ServiceMonitor please follow Prometheus Operator's
[documentation](https://github.com/coreos/prometheus-operator/blob/master/Documentation/user-guides/running-exporters.md).

To learn how to create ServiceMonitor resources for your services please see the [example][example].

### Prometheus Rules and Alerts

Alerting rules are created via PrometheusRule CRD, to learn more about
PrometheusRule please follow Prometheus Operator
[documentation](https://github.com/coreos/prometheus-operator/blob/master/Documentation/user-guides/alerting.md)
and Prometheus
[documentation](https://github.com/prometheus/prometheus/blob/master/docs/configuration/alerting_rules.md).

To learn how to define alert rules for your services please see the
[example](../../examples/prometheus-rules).

## Alerts

The following alerts are already defined for this package.

### kubernetes-apps

| Parameter                         | Description                                                                                                                                                                                                              | Severity | Interval |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | :------: |
| KubePodCrashLooping               | This alert fires if the per-second rate of the total number of restart of a given pod in a 15 minutes time window was above 0 in the last hour, i.e. the pod is stuck in a crash loop.                                   | warning  |    1h    |
| KubePodNotReady                   | This alert fires if at least one pod was stuck in the Pending or Unknown phase in the last hour.                                                                                                                         | warning  |    1h    |
| KubeDeploymentGenerationMismatch  | This alert fires if in the last hour a deployment's observed generation (the revision number recorded in the object status) was different from the metadata generation (the revision number in the deployment metadata). | warning  |   15m    |
| KubeDeploymentReplicasMismatch    | This alert fires if a deployment's replicas number specification was different from the available replicas in the last hour.                                                                                             | warning  |    1h    |
| KubeStatefulSetReplicasMismatch   | This alert fires if a deployment's replicas number specification was different from the available replicas in the last hour.                                                                                             | warning  |   15m    |
| KubeStatefulSetGenerationMismatch | This alert fires if a StatefulSet's replicas number specification was different from the available replicas in the 15 minutes.                                                                                           | warning  |   15m    |
| KubeDaemonSetRolloutStuck         | This alert fires if the percentage of DaemonSet in the ready phase was less than 100% in the last 15 minutes.                                                                                                            | warning  |   15m    |
| KubeDaemonSetNotScheduled         | This alert fires if the desired number of scheduled DaemonSet was higher than the number of currently scheduled DaemonSet in the last 10 minutes.                                                                        | warning  |   10m    |
| KubeDaemonSetMisScheduled         | This alert fires if at least one DaemonSet was running where it was not supposed to run in the last 10 minutes.                                                                                                          | warning  |   10m    |
| KubeCronJobRunning                | This alert fires if at least one CronJob took more than one hour to complete.                                                                                                                                            | warning  |    1h    |
| KubeJobCompletion                 | This alert fires if at least on Job took more than one hour to complete.                                                                                                                                                 | warning  |    1h    |
| KubeJobFailed                     | This alert fires if at least one Job failed in the last hour.                                                                                                                                                            | warning  |    1h    |
| KubeLatestImageTag                | This alert fires if there are images deployed in the cluster tagged with `:latest` and this is really dangerous                                                                                                          | warning  |    1h    |

### kube-prometheus-node-alerting.rules

| Parameter                         | Description                                                                                                                                                                                       | Severity | Interval |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| NodeCPUSaturating                 | This alert fires if, for a given instance, CPU utilisation and saturation were higher than 90% in the last 30 minutes.                                                                            | warning  |   30m    |
| NodeCPUStuckInIOWait              | This alert fires if CPU time in IOWait mode calculated on a 5 minutes window for a given instance was more than 50% in the last 15 minutes.                                                       | warning  |   15m    |
| NodeMemoryRunningFull             | This alert fires if memory utilisation on a given node was higher than 85% in the last 30 minutes.                                                                                                | warning  |   30m    |
| NodeFilesystemUsageCritical       | This alert fires if in the last minute the filesystem usage was more than 90%.                                                                                                                    | critical |    1m    |
| NodeFilesystemFullInFourDays      | This alert fires if in the last 5 minutes the filesystem usage was more than 85% and, based on a linear prediction on the volume usage in the last 6 hours, the volume will be full in four days. | warning  |    5m    |
| NodeFilesystemInodeUsageCritical  | This alert fires if the available inodes in a given filesystem were less than 10% in the last minute.                                                                                             | critical |    1m    |
| NodeFilesystemInodeFullInFourDays | This alert fires if, based on a linear prediction on the inodes usage in the last 6 hours, the filesystem will exhaust its inodes in four days.                                                   | warning  |    5m    |
| NodeNetworkDroppingPackets        | This alerts fires if a given physical network interface was dropping more than 10 pkt/s in the last 30 minutes.                                                                                   | warning  |   30m    |

### prometheus

| Parameter                              | Description                                                                                                                                                                              | Severity | Interval |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| PrometheusConfigReloadFailed           | This alert fires if Prometheus's configuration failed to reload in the last 10 minutes.                                                                                                  | critical |   10m    |
| PrometheusNotificationQueueRunningFull | This alert fires if Prometheus's alert notification queue is running full in the next 30 minutes, based on a linear prediction on the usage in the last 5 minutes.                       | critical |   10m    |
| PrometheusErrorSendingAlerts           | This alert fires if the error rate calculated in a 5 minutes time windows was more than 1% in the last 10 minutes.                                                                       | critical |   10m    |
| PrometheusErrorSendingAlerts           | This alert fires if the error rate calculated in a 5 minutes time windows was more than 3% in the last 10 minutes.                                                                       | critical |   10m    |
| PrometheusNotConnectedToAlertmanagers  | This alert fires if Prometheus was not connected to at least one Alertmanager in the last 10 minutes.                                                                                    | critical |   10m    |
| PrometheusTSDBReloadsFailing           | This alert fires if Prometheus had any failure to reload data blocks from disk in the last 12 hours.                                                                                     | critical |   12h    |
| PrometheusTSDBCompactionsFailing       | This alert fires if Prometheus had any failure to compact sample blocks in the last 12 hours.                                                                                            | critical |   12h    |
| PrometheusTSDBWALCorruptions           | This alert fires if Prometheus had detected any corruption in the write-ahead log in the last 4 hours.                                                                                   | critical |    4h    |
| PrometheusNotIngestingSamples          | This alert fires if Prometheus sample ingestion rate calculated on a 5 minutes time window was below or equal to 0 in the last 10 minutes, i.e. Prometheus is failing to ingest samples. | critical |   10m    |
| PrometheusTargetScrapesDuplicate       | This alert fires if Prometheus was discarding many samples due to duplicated timestamps but different values in the last 10 minutes.                                                     | warning  |   10m    |

### general

| Parameter      | Description                                                                                                                                                      | Severity | Interval |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| TargetDown     | This alert fires if more than 10% of the targets were down in the last 10 minutes.                                                                               | critical |   10m    |
| FdExhaustion   | This alert fires if, based on a linear prediction on file descriptors usage in the last hour minutes, the instance will exhaust its file descriptors in 4 hours. | warning  |   10m    |
| FdExhaustion   | This alert fires if, based on a linear prediction on file descriptors usage in the last 10 minutes, the instance will exhaust its file descriptors in one hour.  | critical |   10m    |
| DeadMansSwitch | This is a DeadMansSwitch meant to ensure that the entire Alerting Pipeline is functional.                                                                        | none     |          |

### kubernetes-system

| Parameter           | Description                                                                                                                                                | Severity | Interval |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| KubeNodeNotReady    | This alert fires if a given node was not in Ready status in the last hour.                                                                                 | critical |    1h    |
| KubeVersionMismatch | This alert fires if the versions of the Kubernetes components were mismatching in the last hour.                                                           | warning  |    1h    |
| KubeClientErrors    | This alert fires if the Kubernetes API client error responses rate calculated in a 5 minutes window was more than 1% in the last 15 minutes.               | warning  |   15m    |
| KubeClientErrors    | This alert fires if the Kubernetes API client error responses rate calculated in a 5 minutes window was more than 0.1 errors / sec in the last 15 minutes. | warning  |   15m    |
| KubeletTooManyPods  | This alert fires if a given kubelet is running more than 100 pods and is approaching the hard limit of 110 pods per node.                                  | warning  |   15m    |
| KubeAPILatencyHigh  | This alert fires if the API server 99th percentile latency was more than 1 second in the last 10 minutes.                                                  | warning  |   10m    |
| KubeAPILatencyHigh  | This alert fires if the API server 99th percentile latency was more than 4 second in the last 10 minutes.                                                  | critical |   10m    |
| KubeAPIErrorsHigh   | This alert fires if the requests error rate calculated in a 5 minutes window was more than 5% in the last 10 minutes.                                      | critical |   10m    |

### kubernetes-storage

| Parameter                               | Description                                                                                                                                 | Severity | Interval |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| KubePersistentVolumeStuck               | This alert fires if a given persisten volume was stuck in the Pending or Failed phase in the last hour.                                     | warning  |    1h    |
| KubePersistentVolumeUsageCritical       | This alert fires if the available space in a given PersistentVolumeClaim was less than 10% in the last minute.                              | critical |    1m    |
| KubePersistentVolumeFullInFourDays      | This alert fires if, based on a linear prediction on the volume usage in the last 6 hours, the volume will be full in four days.            | warning  |    5m    |
| KubePersistentVolumeInodeUsageCritical  | This alert fires if the available inodes in a given PersistentVolumeClaim were less than 10% in the last minute.                            | critical |    1m    |
| KubePersistentVolumeInodeFullInFourDays | This alert fires if, based on a linear prediction on the inodes usage in the last 6 hours, the volume will exhaust its inodes in four days. | warning  |    5m    |

### kubernetes-absent

| Parameter              | Description                                                                                                           | Severity | Interval |
| ---------------------- | --------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| AlertmanagerDown       | This alert fires if Prometheus target discovery was not able to reach AlertManager in the last 15 minutes.            | critical |   15m    |
| KubeAPIDown            | This alert fires if Prometheus target discovery was not able to reach kube-apiserver in the last 15 minutes.          | critical |   15m    |
| KubeStateMetricsDown   | This alert fires if Prometheus target discovery was not able to reach kube-state-metrics in the last 15 minutes.      | critical |   15m    |
| KubeletDown            | This alert fires if Prometheus target discovery was not able to reach the kubelet in the last 15 minutes.             | critical |   15m    |
| NodeExporterDown       | This alert fires if Prometheus target discovery was not able to reach node-exporter in the last 15 minutes.           | critical |   15m    |
| PrometheusDown         | This alert fires if Prometheus target discovery was not able to reach Prometheus in the last 15 minutes.              | critical |   15m    |
| PrometheusOperatorDown | This alert fires if Prometheus target discovery was not able to reach the Prometheus Operator in the last 15 minutes. | critical |   15m    |

### alertmanager

| Parameter                      | Description                                                                                                                                     | Severity | Interval |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| AlertmanagerConfigInconsistent | This alert fires if the configuration of the instances of the Alertmanager cluster were out of sync in the last 5 minutes.                      | critical |    5m    |
| AlertmanagerDownOrMissing      | This alert fires if in the last 5 minutes an unexpected number of Alertmanagers were scraped or Alertmanagers disappered from target discovery. | critical |    5m    |
| AlertmanagerFailedReload       | This alert fires if the Alertmanager's configuration reload failed in the last 10 minutes.                                                      | critical |   10m    |

### kubernetes-resources

| Parameter         | Description                                                                                                                                                           | Severity | Interval |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | :------: |
| KubeCPUOvercommit | This alert fires if the cluster-wide CPU requests from pods in the last 5 minutes were so high to not tolerate a node failure.                                        | warning  |    5m    |
| KubeMemOvercommit | This alert fires if the cluster-wide memory requests from pods in the last 5 minutes were so high to not tolerate a node failure.                                     | warning  |    5m    |
| KubeCPUOvercommit | This alert fires if the hard limit of CPU resources quota in the last 5 minutes is more than 150% of the available resources, i.e. the hard limit is set too high.    | warning  |    5m    |
| KubeMemOvercommit | This alert fires if the hard limit of memory resources quota in the last 5 minutes is more than 150% of the available resources, i.e. the hard limit is set too high. | warning  |    5m    |
| KubeQuotaExceeded | This alert fires if a given resource was used for more than 90% of the corresponding hard quota in the last 15 minutes.                                               | warning  |   15m    |

<!-- Links -->

[prom-gh]: https://github.com/prometheus/prometheus
[prom-doc]: https://prometheus.io/docs/introduction/overview
[example]: https://github.com/sighupio/fury-kubernetes-monitoring/examples/serviceMonitor

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

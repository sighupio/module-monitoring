# Grafana

<!-- <SD-DOCS> -->

Grafana is an open-source data visualization and graph composer platform for
numeric time-series data with Prometheus integration.

## Image repository and tag

- Grafana image: `grafana/grafana:12.1.0`
- Grafana repository: [https://github.com/grafana/grafana](https://github.com/grafana/grafana)
- Grafana documentation: [https://docs.grafana.org](https://docs.grafana.org)
- k8s-sidecar image: `kiwigrid/k8s-sidecar`
- k8s-sidecar repository: <https://github.com/kiwigrid/k8s-sidecar>
- k8s-sidecar documentation: <https://github.com/kiwigrid/k8s-sidecar/blob/master/README.md>

## Requirements

- Kubernetes >= `1.31.0`
- Kustomize = `5.6.0`

## Configuration

Fury distribution Grafana is deployed with the following configuration:

- Replica number: `1`
- Anonymous authentication enabled
- `Admin` role for unauthenticated users
- Resource limits are `200m` for CPU and `200Mi` for memory
- Listens on port `3000`
- Prometheus configured as the data source

## Add new dashboards

Grafana will try to load automatically all the files inside configMaps that have the `grafana-sighup-dashboard` label from **all** namespaces.

To add a custom dashboard to Grafana, follow the next steps:

1. Create a configMap that includes the dashboard definition `json` file (you can include more than one json per configMap)
2. Add the `grafana-sighup-dashboard` **label** to the configMap, the value is not important.
3. If you want to put the dashboard(s) in a specific Grafana folder, for example `myfolder`, add the following **annotation** to the configMap: `grafana-folder: myfolder`.

Look at the [dashboards](dashboards) folder `kustomization.yaml` for some examples.

## Add new datasource

Additionally, you can create a ConfigMap/Secret in your namespace with a datasource definition then labeling it
with the label key `grafana-sighup-datasource`, the value of the label is up to you. Labeling it, the sidecar k8s-sidecar
will take care of it and inject it into a shared volume and send an API reload signal to grafana itself.

Look at the [datasources](datasources) folder `kustomization.yaml` for an example.

## Deployment

You can deploy Grafana by running the following command:

```shell
kustomize build | kubectl apply -f -
```

### Accessing Grafana UI

You can access Grafana Dashboard by port-forwarding on port `3000`:

```shell
kubectl port-forward svc/grafana 3000:3000 --namespace monitoring
```

Grafana will be available on [http://127.0.0.1:3000](http://127.0.0.1:3000) from
your browser.

### Adding/Removing Dashboards

To learn how to add or remove dashboards to Grafana please see the
[examples](../../examples/grafana-add-dashboard) folder.

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

# `kube-proxy-metrics` Package Maintenance

This package has no upstream manifest: it is a SIGHUP package that runs `kube-rbac-proxy` on every node in front of the kube-proxy metrics endpoint. The DaemonSet in `deploy.yml` is generated from the upstream kube-prometheus [`nodeExporter-daemonset.yaml`](https://github.com/prometheus-operator/kube-prometheus/blob/main/manifests/nodeExporter-daemonset.yaml), which is also a `hostNetwork` DaemonSet with a `kube-rbac-proxy` container, removing everything specific to node-exporter.

To prepare a new release of this package:

1. Run the upgrade script with the kube-prometheus release:

   ```bash
   mise run upgrade <kube_prometheus_version>
   # Example
   mise run upgrade v0.18.0
   ```

2. Check the differences introduced in `deploy.yml`: new fields added upstream for node-exporter may need to be removed in the upgrade script.

3. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the image tag in `README.md` to reflect the new version.

> [!NOTE]
> The `dashboards/proxy.json` dashboard is not updated by the `upgrade` task: it is updated by the `grafana` package upgrade (`utils/pull-upstream.sh` moves it here).

# `x509-exporter` Package Maintenance

## Upgrading

To update the x509-exporter package, follow these steps.

> [!IMPORTANT]
> The following commands assume your PWD is `katalog/x509-exporter`.

1. Get the latest available chart version:
   ```bash
   mise run chart-version
   ```

2. Run the upgrade script, specifying the desired chart version:
   ```bash
   mise run upgrade <chart_version>
   # Example
   mise run upgrade 4.2.0
   ```

   This script will:
   - Pull the specified chart version from the `enix` Helm repo
   - Lint the chart against `MAINTENANCE.values.yaml`
   - Generate `deploy.yaml` from the Helm chart template
   - Download the Grafana dashboard JSON into `config/x509-certificate-exporter.json`
   - Patch all labels to `app: x509-certificate-exporter` (with `prometheus: k8s` and `role: alert-rules` on `PrometheusRule`)
   - Patch `spec.selector` and `spec.template.metadata.labels` on DaemonSets, Deployment and Service
   - Run `mise run add-license`

3. Review the changes:

   - `deploy.yaml` — all Kubernetes manifests (generated, do not edit manually)
   - `config/x509-certificate-exporter.json` — Grafana dashboard (downloaded from upstream)
   - `kustomization.yaml` — references `deploy.yaml` and generates the dashboard ConfigMap via `configMapGenerator`
   - `MAINTENANCE.values.yaml` — Helm values used to generate the manifests

4. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

## Notes

The `securityContext` block with the `DAC_READ_SEARCH` capability in `MAINTENANCE.values.yaml` under `hostPathsExporter.daemonSets.control-plane` is required because the [on-prem installer](https://github.com/sighupio/installer-on-premises/pull/163) restricts permissions on `/etc/etcd/pki` to the `etcd` user. Without this capability, the exporter cannot read etcd certificates and logs `permission denied` errors. See [#221](https://github.com/sighupio/module-monitoring/issues/221) and fix commit `2c33b03` for context.

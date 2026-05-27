# `x509-exporter` Package Maintenance

## Upgrading

To update the x509-exporter package, follow these steps.

> [!IMPORTANT]
> The following commands assume your PWD is `katalog/x509-exporter`.

1. Update the Helm repo and check available chart versions:
   ```bash
   helm repo add enix https://charts.enix.io
   helm repo update
   helm search repo enix/x509-certificate-exporter -l
   ```

2. Run the upgrade script, specifying the desired chart version:
   ```bash
   X509_CHART_VERSION=4.1.0 ./upgrade.sh
   ```

   This script will:
   - Pull the specified chart version from the `enix` Helm repo
   - Lint the chart against `MAINTENANCE.values.yaml`
   - Generate `deploy.yaml` from the Helm chart template
   - Download the Grafana dashboard JSON into `config/x509-certificate-exporter.json`
   - Patch all labels to `app: x509-certificate-exporter` (with `prometheus: k8s` and `role: alert-rules` on `PrometheusRule`)
   - Patch `spec.selector` and `spec.template.metadata.labels` on DaemonSets, Deployment and Service
   - For chart 4.1.0, run `patch_4.1.0.sh` to replace the broken `X509ExporterReadErrors` alert with `SourceErrors`/`SourceErrorsSustained` from chart v4.2.0-rc.1
   - Run `mise run add-license`

3. Review the changes:

   - `deploy.yaml` — all Kubernetes manifests (generated, do not edit manually)
   - `config/x509-certificate-exporter.json` — Grafana dashboard (downloaded from upstream)
   - `kustomization.yaml` — references `deploy.yaml` and generates the dashboard ConfigMap via `configMapGenerator`
   - `MAINTENANCE.values.yaml` — Helm values used to generate the manifests

   > **Note:** Chart v4.1.0 ships a broken `X509ExporterReadErrors` alert referencing the removed `x509_read_errors` metric. The `patch_4.1.0.sh` script backports the fix from [v4.2.0-rc.1](https://github.com/enix/x509-certificate-exporter/releases/tag/v4.2.0-rc.1). When we upgrade to chart ≥4.2.0, the patch script can be removed entirely.

4. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

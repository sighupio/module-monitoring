# `grafana` Package Maintenance

To prepare a new release of this package:

1. Run the upgrade script

   ```bash
   export KUBE_PROMETHEUS_RELEASE=v0.17.0
   export K8S_SIDECAR_VERSION=2.7.3
   export DRILLDOWN_VERSION=2.0.4
   ./upgrade.sh
   ```
   
   Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release, `K8S_SIDECAR_VERSION` with the desired k8s-sidecar version, and `DRILLDOWN_VERSION` with the desired Grafana Logs Drilldown plugin version.
   
   The script will pull the upstream release, automatically remove Windows and AIX dashboards from `deployment.yaml`, update the k8s-sidecar image, and update the Drilldown plugin URL in the environment patch.

2. Check the differences introduced by pulling the upstream release and add the necessary patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

5. The `upgrade.sh` script also automatically fetches the latest `kiwigrid/k8s-sidecar` version from GitHub and updates `kustomization.yaml`. Verify the version is correct after running the script.

## Customizations

- We've changed the JSON file inside grafana-dashboardSources, dropping the folder name and enabling the option to use subfolders. This is done via a kustomize patch.
- Added `FOLDER_ANNOTATION` environment variable to the dashboards' sidecar. This is done via a kustomize patch.
- Added custom grafana dashboard (`fury-cluster-overview.json`), which shows an overview of the status of the resources present in the cluster. This is done via a kustomize patch.
- Windows and AIX dashboards are removed automatically by the `upgrade.sh` script (JSON files and volume mounts).
- Added default Kubernetes values for the readiness probe and introduced a liveness probe. The readiness probe defaults allow parameter customization, while the liveness probe was added to enable a more lenient approach to health checks and to recover from application hangs or failures. Both changes are applied using a Kustomize patch.
- Added Grafana Logs Drilldown plugin (`grafana-lokiexplore-app`) via `GF_INSTALL_PLUGINS` environment variable. The plugin version is managed by the `DRILLDOWN_VERSION` env var in `upgrade.sh`.
- Enabled feature toggles `exploreMetricsRelatedLogs` and `exploreLogsShardSplitting` in `grafana.ini` for metrics-to-logs correlation and query streaming.


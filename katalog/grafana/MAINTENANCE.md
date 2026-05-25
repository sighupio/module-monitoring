# `grafana` Package Maintenance

To prepare a new release of this package:

1. Run the upgrade script

   ```bash
   export KUBE_PROMETHEUS_RELEASE=v0.17.0
   ./upgrade.sh
   ```
   
   Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.
   
   The script will pull the upstream release and automatically remove Windows and AIX dashboards from `deployment.yaml`.

2. Check the differences introduced by pulling the upstream release and add the necessary patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

## Customizations

- We've changed the JSON file inside grafana-dashboardSources, dropping the folder name and enabling the option to use subfolders. This is done via a kustomize patch.
- Added `FOLDER_ANNOTATION` environment variable to the dashboards' sidecar. This is done via a kustomize patch.
- Added custom grafana dashboard (`fury-cluster-overview.json`), which shows an overview of the status of the resources present in the cluster. This is done via a kustomize patch.
- Windows and AIX dashboards are removed automatically by the `upgrade.sh` script (JSON files and volume mounts).
- Added default Kubernetes values for the readiness probe and introduced a liveness probe. The readiness probe defaults allow parameter customization, while the liveness probe was added to enable a more lenient approach to health checks and to recover from application hangs or failures. Both changes are applied using a Kustomize patch.


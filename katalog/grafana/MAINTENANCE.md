# `grafana` Package Maintenance

To prepare a new release of this package:

1. Get the current upstream release

```bash
export KUBE_PROMETHEUS_RELEASE=v0.16.0
../../utils/pull-upstream.sh ${KUBE_PROMETHEUS_RELEASE} grafana
```

Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.

2. Check the differences introduced by pulling the upstream release and add the needed patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

## Customizations

- We've changed the json file inside grafana-dashboardSources, dropping the folder name and enabling the option to use subfolders. This is done via a kustomize patch.
- Added `FOLDER_ANNOTATION` environment variable to the dashboards sidecar. This is done via a kustomize patch.
- Added custom grafana dashboard (`fury-cluster-overview.json`), which shows an overview of the status of the resources present in the cluster. This is done via a kustomize patch.
- Windows and AIX dashboards are removed, we don't support these platforms. **This must be manually done when comparing the changes**:
  - The related json dashboards are deleted automatically by the pull script, no need to do it.
  - Edit the `grafana/deployment.yaml` file and remove the lines that mount the Windows and AIX dashboards from the configmaps.

## Considerations

For the release 3.3.0 the Grafana deployment tag was manually set to a newer version because the suggested by the upstream had some issues. For more details, check [this issue](https://github.com/grafana/grafana/issues/92634).

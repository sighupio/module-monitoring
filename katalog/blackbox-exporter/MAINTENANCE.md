# `blackbox-exporter` Package Maintenance

> ⚠️ **Warning**: the `kube-rbac-proxy` version used in this package should be aligned with the one used by the upstream `kube-state-metrics` chart. Bump `katalog/kube-state-metrics` first, then update this package to the same `kube-rbac-proxy` version obtained from its chart.

To prepare a new release of this package:

1. Get the current upstream release

   ```bash
   export KUBE_PROMETHEUS_RELEASE=v0.18.0
   ../../utils/pull-upstream.sh ${KUBE_PROMETHEUS_RELEASE} blackbox-exporter
   ```
   Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.

2. Check the differences introduced by pulling the upstream release and add the necessary patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

> ℹ️ **Note**: `configmap-reload` uses the `v0.15.0-debian12` tag, a rebuild of upstream `v0.15.0` on distroless Debian 12 done in [container-image-sync](https://github.com/sighupio/container-image-sync/blob/main/modules/extra/images.yml), because the upstream image is based on Debian 11 and can no longer be patched for CVEs. When upstream releases a version based on Debian 12 or newer, switch back to the upstream tag.

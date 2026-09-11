# `kube-proxy-metrics` Package Maintenance

> ⚠️ **Warning**: the `kube-rbac-proxy` version used in this package should be aligned with the one used by the upstream `kube-state-metrics` chart. Bump `katalog/kube-state-metrics` first, then update this package to the same `kube-rbac-proxy` version obtained from its chart.

To prepare a new release of this package:

1. Run the upgrade script to bump the `kube-rbac-proxy` image to the desired release:

   ```bash
   mise run upgrade <rbac_proxy_version>
   # Example
   mise run upgrade v0.22.0
   ```

2. Check the differences introduced in `kustomization.yaml` and verify the new tag.

3. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the image tag in `README.md` to reflect the new version.

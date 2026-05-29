# `kube-proxy-metrics` Package Maintenance

To prepare a new release of this package:

1. Run the upgrade script to bump the `kube-rbac-proxy` image to the latest release:

   ```bash
   ./upgrade.sh
   ```

2. Check the differences introduced in `kustomization.yaml` and verify the new tag.

3. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the image tag in `README.md` to reflect the new version.

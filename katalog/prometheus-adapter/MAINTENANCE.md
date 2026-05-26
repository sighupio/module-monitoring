# `prometheus-adapter` Package Maintenance

To prepare a new release of this package:

1. Run the upgrade script

   ```bash
   export KUBE_PROMETHEUS_RELEASE=v0.17.0
   ./upgrade.sh
   ```

   Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release. The script will:
   - Pull upstream manifests from kube-prometheus
   - Extract the adapter config from the Helm chart
   - Generate `config.yaml` from `configMap.yaml`
   - Sync labels in `apiService-EnhancedHPAMetrics.yaml` with upstream
   - Add license headers

2. Check the differences introduced by pulling the upstream release and add the necessary patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

5. Compare the `configMap.yaml` and `config.yaml` files, make sure the common part is up to date and keep the full metrics `rules` `externalRules` `resourceRules` enabled.

## Customizations

We diverge from upstream in the following ways:

1. We changed the config.yaml to a `configMap.yaml` file (step 5.) so we can patch it in the distribution easily when we need it.
2. We add two additional API services (`v1beta1.custom.metrics.k8s.io` and `v1beta1.external.metrics.k8s.io`) via the `apiService-EnhancedHPAMetrics.yaml` file that are not included in upstream kube-prometheus manifests. See: https://github.com/sighupio/module-monitoring/issues/191
3. We add the two additional API services to the ClusterRole via a patch in `kustomization.yaml`, so the adapter can serve them.
4. We extract the adapter config from the Helm chart via `pull-upstream.sh` and inject it into `configMap.yaml`, keeping the full `rules`, `externalRules`, and `resourceRules` enabled.
5. We use `patchesJson6902` in `kustomization.yaml` to override the namespace of the `resource-metrics-auth-reader` RoleBinding to `kube-system`. We can't use regular `patches` because it runs before the namespace transformer, which would overwrite the change. See: https://github.com/kubernetes-sigs/kustomize/issues/5626

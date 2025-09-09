# `prometheus-adapter` Package Maintenance

To prepare a new release of this package:

1. Get the current upstream release

```bash
export KUBE_PROMETHEUS_RELEASE=v0.16.0
../../utils/pull-upstream.sh ${KUBE_PROMETHEUS_RELEASE} prometheus-adapter
```

Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.

2. Check the differences introduced by pulling the upstream release and add the needed patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

5. Compare the `configMap.yaml` and `config.yaml` files, make sure the common part is up-to-date and keep the full metrics `rules` `externalRules` `resourceRules` enabled.

## Customizations

We diverge from upstream in the following ways:

1. We changed the config.yaml to a `configMap.yaml` file (step 5.) so we can patch it in the distribution easily when we need it.
2. We add 2 additional API services via the apiService-EnhancedHPAMetrics.yaml file that are not included in upstream's manifests. See: https://github.com/sighupio/module-monitoring/issues/191
3. We add the 2 additional API services to the ClusterRole via a patch, so the adapter can serve them.

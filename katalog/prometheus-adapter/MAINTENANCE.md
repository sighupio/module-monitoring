# `prometheus-adapter` Package Maintenance

## Directory Structure

This package uses a two-kustomization architecture to cleanly separate resources by namespace:

```
prometheus-adapter/
├── monitoring-resources/      # Resources in the 'monitoring' namespace
│   ├── kustomization.yaml
│   ├── config.yaml           # Adapter configuration
│   └── *.yaml                # All monitoring namespace resources
├── kube-system-resources/    # Resources in the 'kube-system' namespace
│   ├── kustomization.yaml
│   └── roleBindingAuthReader.yaml
├── kustomization.yaml        # Root kustomization (composes the two)
└── config.yaml               # Kept at root for reference

This avoids deprecated kustomize features (`patchesJson6902`) while maintaining proper namespace separation.

## Update Process

To prepare a new release of this package:

1. Get the current upstream release

```bash
export KUBE_PROMETHEUS_RELEASE=v0.16.0
../../utils/pull-upstream.sh ${KUBE_PROMETHEUS_RELEASE} prometheus-adapter
```

Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.

**Note**: The `pull-upstream.sh` script automatically places files in the correct subdirectories.

2. Check the differences introduced by pulling the upstream release and add the needed patches in `monitoring-resources/kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `monitoring-resources/kustomization.yaml` file with the new image.

5. Compare the `config.yaml` files (both root and `monitoring-resources/`), make sure the common part is up-to-date and keep the full metrics `rules` `externalRules` `resourceRules` enabled.

## Customizations

We diverge from upstream in the following ways:

1. **Two-folder architecture**: Resources are separated into `monitoring-resources/` and `kube-system-resources/` to avoid kustomize deprecations.
2. We changed the config.yaml to a `configMap.yaml` approach so we can patch it in the distribution easily when we need it.
3. We add 2 additional API services via the apiService-EnhancedHPAMetrics.yaml file that are not included in upstream's manifests. See: https://github.com/sighupio/module-monitoring/issues/191
4. We add the 2 additional API services to the ClusterRole via a patch, so the adapter can serve them.

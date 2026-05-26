# `prometheus-adapter` Package Maintenance

To prepare a new release of this package:

1. Run the upgrade script

   ```bash
   export KUBE_PROMETHEUS_RELEASE=v0.17.0
   ../../utils/pull-upstream.sh "${KUBE_PROMETHEUS_RELEASE}" prometheus-adapter
   ```

   Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release. The script will:
   - Pull upstream manifests from kube-prometheus
    - Extract the adapter config from the Helm chart
    - Generate `config.yaml` from the rendered Helm template
   - Sync labels in `apiService-EnhancedHPAMetrics.yaml` with upstream
   - Add license headers

2. Check the differences introduced by pulling the upstream release and add the necessary patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

## Customizations

We diverge from upstream in the following ways:

1. We use a `configMapGenerator` in `kustomization.yaml` to embed `config.yaml` as a ConfigMap, so we can patch it in the distribution easily when we need it.
2. We add two additional API services (`v1beta1.custom.metrics.k8s.io` and `v1beta1.external.metrics.k8s.io`) via the `apiService-EnhancedHPAMetrics.yaml` file that are not included in upstream kube-prometheus manifests. See: https://github.com/sighupio/module-monitoring/issues/191
3. We add the two additional API services to the ClusterRole via a patch in `kustomization.yaml`, so the adapter can serve them.
4. We extract the adapter config from the Helm chart via `pull-upstream.sh` and write it to `config.yaml`, keeping the full `rules`, `externalRules`, and `resourceRules` enabled.
5. We use `patchesJson6902` in `kustomization.yaml` to override the namespace of the `resource-metrics-auth-reader` RoleBinding to `kube-system`. We can't use regular `patches` because it runs before the namespace transformer, which would overwrite the change. See: https://github.com/kubernetes-sigs/kustomize/issues/5626

## Generated Configuration

The `config.yaml` file is **auto-generated** and must not be edited manually. It is produced by rendering the `prometheus-community/prometheus-adapter` Helm chart using the values defined in `values/prometheus-adapter.yml`.

The value file contains:
- **Custom rules** (`rules.custom`): metric discovery and query rules derived from the upstream kube-prometheus defaults, with a 1-minute rate window instead of the default 5 minutes.
- **Resource rules** (`rules.resource`): CPU and memory queries for HPA, sourced from the upstream kube-prometheus `resourceRules`.
- **External rules** (`rules.external`): queue-length and queue-size external metric rules from the prometheus-community Helm chart defaults.

During an upgrade, the `pull-upstream.sh` script renders the Helm chart, extracts the generated config, and writes it to `config.yaml`. Any customization to the adapter behavior should be done in `values/prometheus-adapter.yml`.

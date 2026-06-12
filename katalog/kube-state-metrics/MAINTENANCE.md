# `kube-state-metrics` Package Maintenance

To prepare a new release of this package:

1. Get the current upstream release

   ```bash
   export KUBE_PROMETHEUS_RELEASE=v0.17.0
   ../../utils/pull-upstream.sh ${KUBE_PROMETHEUS_RELEASE} kube-state-metrics
   ```

   Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.

2. Check the differences introduced by pulling the upstream release and add the necessary patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file container-image-sync repository](https://github.com/sighupio/container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

5. Note on `--resources` flag: starting from KSM v2.18.0, `endpoints` was removed from the default resources (replaced by `endpointslices`). However, `endpoints` is still needed because `kube_endpoint_address` is used by the `MimirGossipMembersEndpointsOutOfSync` alert in `katalog/mimir/prometheusRules.yaml`. Since the `--resources` flag replaces the entire default list, the deployment explicitly lists all 28 default resources plus `endpoints`. When updating KSM, fetch the new default list from `pkg/options/resource.go` in the `kubernetes/kube-state-metrics` repository at the target version tag, append `endpoints`, and update the flag accordingly.

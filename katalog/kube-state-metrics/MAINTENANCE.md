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

5. Note on `--resources` flag: kube-state-metrics 2.18.0 replaced `endpoints` with `endpointslices` as the default resource. The flag `--resources=endpoints,endpointslices` is required to keep `kube_endpoint_address` metrics (used by `MimirGossipMembersEndpointsOutOfSync` alert in `katalog/mimir/prometheusRules.yaml`). Without this flag, the alert breaks because `kube_endpoint_address` is no longer emitted.

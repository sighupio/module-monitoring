# `node-exporter` Package Maintenance

To prepare a new release of this package:

1. Get the current upstream release

```bash
export KUBE_PROMETHEUS_RELEASE=v0.16.0
../../utils/pull-upstream.sh ${KUBE_PROMETHEUS_RELEASE} node-exporter
```

Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.

2. Check the differences introduced by pulling the upstream release and add the needed patches in `kustomization.yaml`

3. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

4. Update the `kustomization.yaml` file with the new image.

## Customizations

We added the `GOMAXPROCS=1` environment variable to limit the goroutines to 1 processor because node-exporter was getting hard throttled by Kubernetes when using all the host CPUs. The patch is done in the `kustomization.yaml` file.

This change will also be included in upstream later and then can be deleted. See:

- <https://github.com/sighupio/fury-kubernetes-monitoring/issues/106>
- <https://github.com/prometheus/node_exporter/pull/2530>

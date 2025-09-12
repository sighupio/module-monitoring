# `x509-exporter` Package Maintenance

> [!NOTE]
> This maintenance guide needs some love, please improve it while you work on the module.
> Step 3. in particular has _draw the rest of the owl_ vibes.
> We probably need to pass the right values to the chart, there's a starting point
> in the `MAINTENANCE.values.yaml` file, but I ran out of time.
> Any little improvement to this guide is welcome.

To prepare a new release of this package:

1. Get the latest release from upstream: https://github.com/enix/x509-certificate-exporter/releases

2. Generate the manifest using the right version:

```bash
mkdir temp && cd temp
helm repo add enix https://charts.enix.io
helm template x509-certificate-exporter enix/x509-certificate-exporter --version 3.19.1 > manifests.yaml # you can try passing the --values MAINTENANCE.values.yaml flag too
# optional: split the manifest into several files for easier comparing:
yq -s '.kind + .metadata.name' manifests.yaml
```

3. Check the differences between `manifests.yaml` and the manifests within this repository tree, adjust everything accordingly.

NOTE: The labels added by Helm have been removed and changed to `app: x509-certificate-exporter`

NOTE2: Grafana dashboard is taken from: https://github.com/enix/x509-certificate-exporter/blob/v3.19.1/deploy/charts/x509-certificate-exporter/grafana-dashboards/x509-certificate-exporter.json or take it from the generated configmap.

1. Sync the new image to our registry in the [`monitoring` images.yaml file fury-distribution-container-image-sync repository](https://github.com/sighupio/fury-distribution-container-image-sync/blob/main/modules/monitoring/images.yml).

2. Update each `kustomization.yaml` file with the new image.

3. Remove the temporary directory

```bash
rm -rf temp
```

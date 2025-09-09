# `kubeadm-sm` Package Maintenance

To prepare a new release of this package:

1. Get the current upstream release

```bash
export KUBE_PROMETHEUS_RELEASE=v0.16.0
../../utils/pull-upstream.sh ${KUBE_PROMETHEUS_RELEASE} kubeadm-sm
```

Replace `KUBE_PROMETHEUS_RELEASE` with the current upstream release.

2. Check the differences introduced by pulling the upstream release and add the needed patches in `kustomization.yaml`

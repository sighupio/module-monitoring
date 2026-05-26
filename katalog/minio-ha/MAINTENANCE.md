# MinIO HA - maintenance

To upgrade the MinIO package, run:

```bash
./upgrade.sh
```

The script automatically:

1. Fetches the latest release from [chainguard-forks/minio](https://github.com/chainguard-forks/minio/releases)
2. Fetches the latest mc release from [minio/mc](https://github.com/minio/mc/releases)
3. Downloads and extracts the Helm chart
4. Updates image tags in `MAINTENANCE.values.yaml` and `kustomization.yaml`
5. Re-renders `deploy.yaml` (excluding the ConfigMap, which is managed via kustomize)
6. Runs `mise run add-license`

# MinIO HA - maintenance

Before running the script, check available versions:

1. Check the latest MinIO version: https://github.com/chainguard-forks/minio/releases
2. Check the latest MC version: https://github.com/minio/mc/releases

Then run the upgrade script:

```bash
MINIO_VERSION=RELEASE.2026-05-20T23-44-52Z MC_VERSION=RELEASE.2025-08-13T08-35-41Z ./upgrade.sh
```

The script automatically:

1. Fetches the specified release from [chainguard-forks/minio](https://github.com/chainguard-forks/minio/releases)
2. Fetches the specified mc release from [minio/mc](https://github.com/minio/mc/releases)
3. Downloads and extracts the Helm chart
4. Updates image tags in `MAINTENANCE.values.yaml` and `kustomization.yaml`
5. Re-renders `deploy.yaml` (excluding the ConfigMap, which is managed via kustomize)
6. Runs `mise run add-license`

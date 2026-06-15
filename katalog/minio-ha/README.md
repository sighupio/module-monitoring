# MinIO HA

<!-- <SD-DOCS> -->

MinIO is a popular distributed object storage system that allows organizations to deploy highly available
and scalable storage infrastructure.
To achieve high availability (HA) for MinIO, a cluster of multiple MinIO nodes must be deployed backed by their own set of PVCs.

## Requirements

- Kubernetes >= `1.32.0`
- Kustomize = `5.6.0`
- [prometheus-operator from SD monitoring module][prometheus-operator]

> Prometheus Operator is necessary since we configure a `ServiceMonitor` to make
> some metrics available from `minio` on prometheus

## Image repository and tag

* MinIO image: `minio/minio`
* MinIO repo: [MinIO on GitHub][minio-gh]

## Configuration

MinIO HA is deployed in the following configuration:

- Three Pod MinIO statefulset with 2 PVCs per Pod
- Custom init Job to initialize buckets (`loki` and `errors`)  and default retention (7 days on `errors` bucket)

## Deployment

You can deploy minio-ha by running the following command in the root of
the project:

```shell
kustomize build | kubectl apply -f -
```

<!-- Links -->

[prometheus-operator]: https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/katalog/prometheus-operator
[minio-gh]: https://github.com/minio/minio

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

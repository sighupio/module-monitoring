# Blackbox exporter

<!-- <SD-DOCS> -->

The blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.

*Source:* [prometheus/blackbox_exporter](https://github.com/prometheus/blackbox_exporter)

## Requirements

- Kubernetes >= `1.31.0`
- Kustomize = `5.6.0`
- [prometheus-operator](../prometheus-operator)

## Image repository and tag

- Blackbox exporter image: `registry.sighup.io/fury/prometheus/blackbox-exporter:v0.27.0`
- Blackbox exporter repository: [Blackbox exporter on GitHub][blackbox-exporter-gh]
- Kubernetes ConfigMap Reload image: `registry.sighup.io/fury/jimmidyson/configmap-reload:v0.15.0`
- Kubernetes ConfigMap Reload repository: [Kubernetes ConfigMap Reload on GitHub][configmap-reload-gh]
- kube-rbac-proxy image: `registry.sighup.io/fury/brancz/kube-rbac-proxy:v0.19.1`
- kube-rbac-proxy repository: [kube-rbac-proxy on Github][krp-gh]

## Configuration

Blackbox exporter is deployed with the following configuration:

- Resource limits are `20m` for CPU and `40Mi` for memory
- Listens on port 9115
- Metrics are scraped by Prometheus every 30s
- Probes available:
  - HTTP 200 GET (`http_2xx`)
  - HTTP 200 POST (`http_post_2xx`)
  - IRC (`irc_banner`)
  - POP3S (`pop3s_banner`)
  - SSH (`ssh_banner`)
  - TCP (`tcp_connect`)

To learn how to instruct Prometheus to check Blackbox exporter probes, please see the [examples](../../examples/blackbox-exporter-probe) folder.

## Deployment

You can deploy blackbox-exporter by running the following command:

```shell
kustomize build katalog/blackbox-exporter | kubectl apply -f - --server-side
```

<!-- Links -->

[blackbox-exporter-gh]: https://github.com/prometheus/blackbox_exporter
[configmap-reload-gh]: https://github.com/jimmidyson/configmap-reload
[krp-gh]: https://github.com/brancz/kube-rbac-proxy

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)

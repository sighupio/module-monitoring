# Endpoint blackbox probing with Probe CRD

This example shows how to define a Probe resource to monitor an endpoint
reachable via HTTP and HTTPS protocols using blackbox-exporter. To learn more
about the Probe resource, see the Prometheus Operator API reference
[documentation](https://github.com/prometheus-operator/prometheus-operator/blob/v0.57.0/Documentation/api.md#probespec).

This example shows the `Probe` resource definition only; the Blackbox exporter
itself is deployed as part of the Monitoring Module when you create a cluster
with `furyctl`. See the [module documentation](../../README.md) for details.

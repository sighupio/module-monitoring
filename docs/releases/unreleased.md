# Monitoring Module Release TDB

Welcome to the latest release of the `monitoring` core module of the [`SIGHUP Distribution`](https://github.com/sighupio/distribution), maintained by team SIGHUP by ReeVo.

## Bug Fixes 🐞

- [[#220](https://github.com/sighupio/module-monitoring/pull/220)] Updates the deprecated etcd_debugging_mvcc_db_total_size_in_bytes Prometheus metric to the promoted etcd_mvcc_db_total_size_in_bytes to fix the "Database Size" panel in the etcd Grafana dashboard.

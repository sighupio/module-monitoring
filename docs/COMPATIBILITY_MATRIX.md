# Compatibility Matrix

| Module Version / Kubernetes Version | 1.20.X             | 1.21.X             | 1.22.X             | 1.23.X             | 1.24.X             | 1.25.X             | 1.26.X             | 1.27.X             | 1.28.X             | 1.29.X             |1.30.X             |1.31.X             |1.32.X             |
|-------------------------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------|-------------------|-------------------|-------------------|
| v1.14.2                             | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:          |                    |                    |                    |                    |                    |                    |                   |                   |                   |
| v2.0.0                              |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                   |                   |                   |
| v2.0.1                              |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                   |                   |                   |
| v2.1.0                              |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                   |                   |                   |
| v2.2.0                              |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: |                    |                    |                    |                   |                   |                   |
| v3.0.0                              |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: |                    |                    |                   |                   |                   |
| v3.0.1                              |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: |                    |                    |                   |                   |                   |
| v3.0.2                              |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: |                    |                    |                   |                   |                   |
| v3.1.0                              |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                   |                   |                   |
| v3.2.0                              |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                   |                   |                   |
| v3.3.0                              |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: |:white_check_mark: |:white_check_mark: |:white_check_mark: |
| v3.3.1                              |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: |:white_check_mark: |:white_check_mark: |:white_check_mark: |
| v3.4.0                              |                    |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: |:white_check_mark: |:white_check_mark: |:white_check_mark: (tech preview) |
| v3.5.0                              |                    |                    |                    |                    |                    |                    |                    |                    |                    | :white_check_mark: |:white_check_mark: |:white_check_mark: |:white_check_mark: |

- :white_check_mark: Compatible
- :warning: Has issues
- :x: Incompatible

## Warning

- [kube-state-metrics](katalog/kube-state-metrics) is not able to scrape
    `ValidatingWebhookConfiguration` in Kubernetes < 1.16.X.
- :warning: : module version: `v1.11.0` and Kubernetes Version: `1.20.x`. It works as expected. Marked as warning
because it is not officially supported by [SIGHUP](https://sighup.io).
- :warning: : module version: `v1.12.0` and Kubernetes Version: `1.21.x`. It works as expected. Marked as warning
because it is not officially supported by [SIGHUP](https://sighup.io).
- :warning: : module version: `v1.13.0` and Kubernetes Version: `1.22.x`. It works as expected. Marked as warning
because it is not officially supported by [SIGHUP](https://sighup.io).
- :x: module version `v1.14.0` has a known bug breaking upgrades. Please do not use.

## Legacy versions

| Module Version / Kubernetes Version |       1.14.X       |       1.15.X       |       1.16.X       |       1.17.X       |       1.18.X       |       1.19.X       |       1.20.X       |       1.21.X       |  1.22.X   |
| ----------------------------------- | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :----------------: | :-------: |
| v1.0.0                              |                    | :white_check_mark: |                    |                    |                    |                    |                    |                    |           |
| v1.1.0                              | :white_check_mark: | :white_check_mark: |        :x:         |                    |                    |                    |                    |                    |           |
| v1.2.0                              | :white_check_mark: | :white_check_mark: |        :x:         |                    |                    |                    |                    |                    |           |
| v1.3.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.4.0                              |     :warning:      |     :warning:      | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.4.1                              |     :warning:      |     :warning:      | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.5.0                              |     :warning:      |     :warning:      | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.6.0                              |     :warning:      |     :warning:      | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.6.1                              |     :warning:      |     :warning:      | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.7.0                              |     :warning:      |     :warning:      | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.7.1                              |     :warning:      |     :warning:      | :white_check_mark: |                    |                    |                    |                    |                    |           |
| v1.8.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |           |
| v1.9.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |           |
| v1.10.0                             |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |                    |           |
| v1.10.1                             |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |                    |           |
| v1.10.2                             |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |                    |           |
| v1.11.0                             |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |                    |           |
| v1.12.0                             |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |           |
| v1.12.1                             |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |           |
| v1.12.2                             |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |     :warning:      |           |
| v1.13.0                             |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning: |
| v1.14.0                             |                    |                    |                    |                    |                    |                    |        :x:         |        :x:         |    :x:    |

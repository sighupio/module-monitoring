#!/usr/bin/env bats
# Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./helper

# VAP is not available on Kubernetes versions 1.29 and below
@test "Deploy VAP to check only images from SIGHUP's registry are used" {
  info
  deploy() {
    kubectl apply --server-side -f katalog/tests/vap-registry.yaml
  }
  if [[ $(kubectl version | grep Server | awk '{print $3}' | cut -d. -f2) -le 29 ]]; then
    skip "Skipping VAP deployment on Kubernetes versions 1.29 and below"
  fi
  run deploy
  [ "$status" -eq 0 ]
}

@test "Applying PrometheusRule and ServiceMonitor CRDs" {
  info
  setup() {
    kubectl apply --server-side -f katalog/prometheus-operator/crds/0servicemonitorCustomResourceDefinition.yaml
    kubectl apply --server-side -f katalog/prometheus-operator/crds/0prometheusruleCustomResourceDefinition.yaml
  }
  loop_it setup 60 10
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy prometheus-operator" {
  info
  deploy() {
    apply katalog/prometheus-operator
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "prometheus-operator is Running" {
  info
  test() {
    check_deploy_ready "prometheus-operator" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy prometheus-operated" {
  info
  deploy() {
    apply katalog/prometheus-operated
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "prometheus-operated is Running" {
  info
  test() {
    check_sts_ready "prometheus-k8s" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy alertmanager-operated" {
  info
  deploy() {
    apply katalog/alertmanager-operated
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "alertmanager-operated is Running" {
  info
  test() {
    check_sts_ready "alertmanager-main" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy blackbox-exporter" {
  info
  deploy() {
    apply katalog/blackbox-exporter
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "blackbox-exporter is Running" {
  info
  test() {
    check_deploy_ready "blackbox-exporter" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy Grafana" {
  info
  deploy() {
    apply katalog/grafana
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "Grafana is Running" {
  info
  test() {
    check_deploy_ready "grafana" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy kube-state-metrics" {
  info
  deploy() {
    apply katalog/kube-state-metrics
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "kube-state-metrics is Running" {
  info
  test() {
    check_deploy_ready "kube-state-metrics" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy kubeadm-sm" {
  info
  deploy() {
    apply katalog/kubeadm-sm
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "Deploy node-exporter" {
  info
  deploy() {
    apply katalog/node-exporter
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "node-exporter is Running" {
  info
  test() {
    check_ds_ready "node-exporter" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy prometheus-adapter" {
  info
  deploy() {
    apply katalog/prometheus-adapter
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "prometheus-adapter is Running" {
  info
  test() {
    check_deploy_ready "prometheus-adapter" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy kube-proxy-metrics" {
  info
  deploy() {
    apply katalog/kube-proxy-metrics
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "kube-proxy-metrics is Running" {
  info
  test() {
    check_ds_ready "kube-proxy-metrics" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy x509-exporter" {
  info
  deploy() {
    apply katalog/tests/x509-exporter
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "x509-certificate-exporter-control-plane is Running" {
  info
  test() {
    check_ds_ready "x509-certificate-exporter-control-plane" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "x509-certificate-exporter-data-plane is Running" {
  info
  test() {
    check_ds_ready "x509-certificate-exporter-data-plane" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy minIO for Mimir" {
  info
  deploy() {
    apply katalog/minio-ha
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "minIO is Running" {
  info
  test() {
    check_sts_ready "minio-monitoring" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy Mimir" {
  info
  deploy() {
    apply katalog/mimir
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "Mimir is Running" {
  info
  test() {
    check_deploy_ready "mimir-distributed-continuous-test" "monitoring"
    check_deploy_ready "mimir-distributed-distributor" "monitoring"
    check_deploy_ready "mimir-distributed-gateway" "monitoring"
    check_deploy_ready "mimir-distributed-querier" "monitoring"
    check_deploy_ready "mimir-distributed-query-frontend" "monitoring"
    check_deploy_ready "mimir-distributed-query-scheduler" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

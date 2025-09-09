#!/usr/bin/env bats
# Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./helper

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
    check_sts_ready "prometheus-prometheus" "monitoring"
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
    check_sts_ready "alertmanager-alertmanager" "monitoring"
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

@test "Deploy grafana" {
  info
  deploy() {
    apply katalog/grafana
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "grafana is Running" {
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

@test "x509-exporter is Running" {
  info
  test() {
    check_ds_ready "x509-certificate-exporter" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy minio for mimir" {
  info
  deploy() {
    apply katalog/minio-ha
  }
  run deploy
  [ "$status" -eq 0 ]
}

@test "Minio is Running" {
  info
  test() {
    check_sts_ready "minio" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

@test "Deploy mimir" {
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
    check_sts_ready "mimir" "monitoring"
  }
  loop_it test 30 5
  status=${loop_it_result:?}
  [ "$status" -eq 0 ]
}

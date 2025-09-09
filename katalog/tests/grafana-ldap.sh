#!/usr/bin/env bats
# Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./helper

@test "Deploy example LDAP instance" {
    info
    setup_ldap(){
        kubectl create ns demo-ldap
        kubectl create configmap ldap-ldif --from-file=sighup.io.ldif=katalog/tests/grafana-ldap-auth/ldap-server/sighup.io-groups.ldif -n demo-ldap --dry-run=client -o yaml | kubectl apply -f -
        kubectl apply -f katalog/tests/grafana-ldap-auth/ldap-server/ldap-server.yaml -n demo-ldap
    }
    run setup_ldap
    [ "$status" -eq 0 ]
}

@test "Wait for example LDAP instance" {
    info
    test(){
        check_deploy_ready "ldap-server" "demo-ldap"
    }
    loop_it test 30 2
    status=${loop_it_result:?}
    [ "$status" -eq 0 ]
}

@test "Deploy Grafana patched with LDAP auth" {
  info
  deploy() {
    apply katalog/tests/grafana-ldap-auth/kustomize-project
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

@test "Test Angel LDAP user in Grafana" {
    info
    test(){
        grafana_pod=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{.items[*].metadata.name}')
        user_info=$(kubectl -n monitoring exec -it "${grafana_pod}" -- wget -qO- http://angel:angel@localhost:3000/api/user)
        # Check that isGrafanaAdmin is false for Angel (non-admin user)
        grep -q '"isGrafanaAdmin":false' <<< "${user_info}"
    }
    run test
    echo $output
    [ "$status" -eq 0 ]
}

@test "Test Jacopo LDAP user in Grafana" {
    info
    test(){
        grafana_pod=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{.items[*].metadata.name}')
        user_info=$(kubectl -n monitoring exec -it "${grafana_pod}" -- wget -qO- http://jacopo:admin@localhost:3000/api/user)
        # Check that isGrafanaAdmin is true for Jacopo (admin user)
        grep -q '"isGrafanaAdmin":true' <<< "${user_info}"
    }
    run test
    echo $output
    [ "$status" -eq 0 ]
}

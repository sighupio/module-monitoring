#!/usr/bin/env bats
# Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.


load ./helper

@test "Grafana apply" {
    run apply katalog/grafana
    [ "$status" -eq 0 ]
}

@test "Wait for Grafana instance" {
    info
    test(){
        status=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath="{.items[*].status.phase}")
        if [ "${status}" != "Running" ]; then return 1; fi
    }
    loop_it test 30 2
    status=${loop_it_result:?}
    [ "$status" -eq 0 ]
}

@test "Deploy example ldap instance" {
    info
    setup_ldap(){
        kubectl create ns demo-ldap
        kubectl create configmap ldap-ldif --from-file=sighup.io.ldif=katalog/tests/grafana-ldap-auth/ldap-server/sighup.io-groups.ldif -n demo-ldap --dry-run=client -o yaml | kubectl apply -f -
        kubectl apply -f katalog/tests/grafana-ldap-auth/ldap-server/ldap-server.yaml -n demo-ldap
    }
    run setup_ldap
    [ "$status" -eq 0 ]
}

@test "Wait for example ldap instance" {
    info
    test(){
        check_deploy_ready "ldap-server" "demo-ldap"
    }
    loop_it test 30 2
    status=${loop_it_result:?}
    [ "$status" -eq 0 ]
}

@test "Apply Grafana LDAP Configuration" {
    info
    run apply katalog/tests/grafana-ldap-auth/kustomize-project
    [ "$status" -eq 0 ]
}

@test "Rollout Grafana" {
    info
    rollout(){
        kubectl patch deployment grafana -n monitoring -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"$(date +'%s')\"}}}}}"
    }
    run rollout
    [ "$status" -eq 0 ]
}

@test "Wait for Grafana instance restart" {
    info
    test(){
        check_deploy_ready "grafana" "monitoring"
    }
    loop_it test 30 2
    status=${loop_it_result:?}
    [ "$status" -eq 0 ]
}

@test "Test Angel LDAP user in Grafana" {
    info
    test(){
        grafana_pod=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{.items[*].metadata.name}')
        user_info=$(kubectl -n monitoring exec -it "${grafana_pod}" -- wget -qO- http://angel:angel@localhost:3000/api/user)
        # Check that isGrafanaAdmin is false for Angel (non-admin user)
        echo "${user_info}" | grep -q '"isGrafanaAdmin":false'
    }
    run test
    [ "$status" -eq 0 ]
}

@test "Test Jacopo LDAP user in Grafana" {
    info
    test(){
        grafana_pod=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{.items[*].metadata.name}')
        user_info=$(kubectl -n monitoring exec -it "${grafana_pod}" -- wget -qO- http://jacopo:admin@localhost:3000/api/user)
        # Check that isGrafanaAdmin is true for Jacopo (admin user)
        echo "${user_info}" | grep -q '"isGrafanaAdmin":true'
    }
    run test
    [ "$status" -eq 0 ]
}

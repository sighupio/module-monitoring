#!/usr/bin/env bats

# Module Monitoring Test Helper Functions
# ========================================
# This file provides helper functions for BATS testing of the monitoring module.
# Enhanced with comprehensive helper functions for robust testing.
# Key functions:
# - apply/delete: Deploy/remove Kustomize resources using kapp for GitOps-style management  
# - check_*_ready: Validate that different Kubernetes resource types are ready
# - loop_it: Retry mechanism for test conditions with configurable timeout
# - info/show: Display test progress information

# shellcheck disable=SC2086,SC2154,SC2034

set -o pipefail

kaction(){
    path=$1
    verb=$2
    kustomize build $path | kubectl $verb -f -
}

apply (){
  APP_NAME=${2:-$(basename $1)}  # Use second parameter or directory basename
  kustomize build $1 >&2
  kustomize build $1 | kapp deploy -a "$APP_NAME" -f - --yes 2>&3
}

delete (){
  APP_NAME=${2:-$(basename $1)}  # Use second parameter or directory basename  
  kustomize build $1 >&2
  kapp delete -a "$APP_NAME" --yes 2>&3
}

info(){
  echo -e "${BATS_TEST_NUMBER}: ${BATS_TEST_DESCRIPTION}" >&3
}

# Display visible messages during BATS test execution
show() {
  echo "# $*" >&3
}

loop_it(){
  retry_counter=0
  max_retry=${2:-100}
  wait_time=${3:-2}
  run ${1}
  ko=${status}
  loop_it_result=${ko}
  while [[ ko -ne 0 ]]
  do
    if [ $retry_counter -ge $max_retry ]; then 
      echo "Timeout waiting for the command to succeed"
      echo "Last command output was:"
      echo "${output}"
      return 1
    fi
    sleep ${wait_time} && echo "# waiting..." $retry_counter >&3
    run ${1}
    ko=${status}
    loop_it_result=${ko}
    retry_counter=$((retry_counter + 1))
  done
  return 0
}

check_sts_ready() {
  local name=$1
  local namespace=$2
  local replicas ready_replicas
  replicas=$(kubectl get sts "$name" -n "$namespace" -o jsonpath='{.status.replicas}' 2>/dev/null || echo "0")
  ready_replicas=$(kubectl get sts "$name" -n "$namespace" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
  [ "$replicas" -eq "$ready_replicas" ] && [ "$replicas" -gt 0 ]
}

check_ds_ready() {
  local name=$1
  local namespace=$2
  local desired ready
  desired=$(kubectl get ds "$name" -n "$namespace" -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null || echo "0")
  ready=$(kubectl get ds "$name" -n "$namespace" -o jsonpath='{.status.numberReady}' 2>/dev/null || echo "0")
  [ "$desired" -eq "$ready" ] && [ "$desired" -gt 0 ]
}

check_deploy_ready() {
  local name=$1
  local namespace=$2
  local replicas ready_replicas
  replicas=$(kubectl get deploy "$name" -n "$namespace" -o jsonpath='{.status.replicas}' 2>/dev/null || echo "0")
  ready_replicas=$(kubectl get deploy "$name" -n "$namespace" -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo "0")
  [ "$replicas" -eq "$ready_replicas" ] && [ "$replicas" -gt 0 ]
}

check_job_ready() {
  local name=$1
  local namespace=$2
  local succeeded
  succeeded=$(kubectl get job "$name" -n "$namespace" -o jsonpath='{.status.succeeded}' 2>/dev/null || echo "0")
  [ "$succeeded" -eq 1 ]
}

check_http_endpoint_ready() {
  # Generic function to check if HTTP endpoint returns acceptable status codes
  local url=$1
  local acceptable_codes=$2
  local status_code
  
  # Get HTTP status code
  status_code=$(curl -k -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")
  
  # Check if status code matches any acceptable code
  for code in $acceptable_codes; do
    if [ "$status_code" = "$code" ]; then
      return 0
    fi
  done
  
  return 1
}

#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -e

# Script to create Kind cluster for E2E testing of monitoring components
# Usage: ./create-e2e-cluster.sh [KUBE_VERSION]
# Example: ./create-e2e-cluster.sh 1.33.0

KUBE_VERSION="${1:-1.33.0}"

# Validate Kubernetes version format
if ! echo "$KUBE_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo "❌ Error: KUBE_VERSION must be in format X.Y.Z (e.g., 1.33.0)"
    echo "Usage: $0 [KUBE_VERSION]"
    exit 1
fi

echo "🚀 Creating E2E Test Cluster for Module Monitoring"
echo "=================================================="

# Configuration
export DRONE_BUILD_NUMBER="${DRONE_BUILD_NUMBER:-9999}"
export DRONE_REPO_NAME="${DRONE_REPO_NAME:-module-monitoring}"
CLUSTER_NAME="${DRONE_REPO_NAME}-${DRONE_BUILD_NUMBER}-${KUBE_VERSION//./}"
KUBECONFIG_PATH="$(pwd)/kubeconfig-e2e"

echo "📋 Configuration:"
echo "   Kubernetes Version: ${KUBE_VERSION}"
echo "   Cluster Name: ${CLUSTER_NAME}"
echo "   Kubeconfig: ${KUBECONFIG_PATH}"

# Check if cluster already exists
if kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
    echo "⚠️  Cluster '${CLUSTER_NAME}' already exists. Deleting first..."
    kind delete cluster --name "${CLUSTER_NAME}"
fi

echo "📦 Step 1: Creating Kind cluster..."

# Use the existing Kind config for multi-node setup
KIND_CONFIG="katalog/tests/kind/config.yml"

echo "   Using Kind node image: registry.sighup.io/fury/kindest/node:v${KUBE_VERSION}"
echo "   Using multi-node config: ${KIND_CONFIG}"

# Create cluster with proper networking for monitoring components
kind create cluster \
    --name "${CLUSTER_NAME}" \
    --image "registry.sighup.io/fury/kindest/node:v${KUBE_VERSION}" \
    --config "${KIND_CONFIG}"

echo "📋 Step 2: Setting up kubeconfig..."
kind get kubeconfig --name "${CLUSTER_NAME}" > "${KUBECONFIG_PATH}"
if [[ "${DRONE_BUILD_NUMBER}" != "9999" ]]; then
  # If we are running in CI 0.0.0.0 is unreachable from within the containers, so we change to the Host's IP on the Docker network
  yq -i '.clusters[0].cluster.server |= sub("(https?://)(.+):(.+)", "${1}172.17.0.1:${3}")' "${KUBECONFIG_PATH}"
fi
export KUBECONFIG="${KUBECONFIG_PATH}"

echo "⏳ Step 3: Waiting for cluster to be ready..."
until kubectl get serviceaccount default; do 
  echo "   Waiting for control-plane..." 
  sleep 2
done

echo "🔍 Step 4: Cluster validation..."
echo "   Nodes:"
kubectl get nodes -o wide
echo "   System pods:"
kubectl get pods -A --field-selector=status.phase!=Succeeded

# Save environment details for test scripts
ENV_FILE="env-${CLUSTER_NAME}.env"
cat > "${ENV_FILE}" <<EOF
export CLUSTER_NAME="${CLUSTER_NAME}"
export KUBECONFIG="${KUBECONFIG_PATH}"
export KUBE_VERSION="${KUBE_VERSION}"
export KIND_CONFIG="${KIND_CONFIG}"
EOF

echo "✅ E2E cluster created successfully!"
echo "   Environment file: ${ENV_FILE}"
echo "   Ready for monitoring components E2E testing"

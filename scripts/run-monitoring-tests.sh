#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -e

echo "🧪 Running Monitoring E2E Test Suite"
echo "===================================="

# Load environment if available
ENV_PATTERN="env-*-monitoring-*.env"
ENV_FILE=$(ls ${ENV_PATTERN} 2>/dev/null | head -1 || echo "")

if [[ -n "$ENV_FILE" && -f "$ENV_FILE" ]]; then
    echo "📋 Loading environment from: $ENV_FILE"
    source "$ENV_FILE"
else
    echo "⚠️  No environment file found (${ENV_PATTERN})"
    echo "   Using default values..."
    export KUBECONFIG="${KUBECONFIG:-$(pwd)/kubeconfig-e2e}"
fi

# Validate kubeconfig exists and cluster is accessible
if [[ ! -f "$KUBECONFIG" ]]; then
    echo "❌ Error: Kubeconfig not found at: $KUBECONFIG"
    echo "   Run ./scripts/create-e2e-cluster.sh first"
    exit 1
fi

echo "🔍 Pre-test validation..."
echo "   Kubeconfig: $KUBECONFIG"
echo "   Cluster access:"
if ! kubectl get nodes > /dev/null 2>&1; then
    echo "❌ Error: Cannot access cluster with current kubeconfig"
    echo "   Ensure cluster is running and kubeconfig is correct"
    exit 1
fi
kubectl get nodes

echo "🧪 Step 1: Running monitoring component tests..."

# Check for required test files
TEST_FILES=(
    "./katalog/tests/tests.sh"
    "./katalog/tests/grafana-ldap.sh"
)

for test_file in "${TEST_FILES[@]}"; do
    if [[ ! -f "$test_file" ]]; then
        echo "⚠️  Warning: Test file not found: $test_file (skipping)"
        continue
    fi
    
    echo ""
    echo "📝 Running: $test_file"
    echo "   BATS command: bats -t $test_file"
    echo ""
    
    # Run the tests with verbose output
    if bats -t "$test_file"; then
        echo "   ✅ Tests passed: $test_file"
    else
        echo "   ❌ Tests failed: $test_file"
        exit 1
    fi
done

echo ""
echo "✅ All monitoring E2E tests completed successfully!"
echo "🎯 All monitoring components verified"
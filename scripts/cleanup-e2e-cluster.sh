#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -e

echo "🧹 Cleaning up E2E Test Environment"
echo "===================================="

# Function to cleanup monitoring test environment
cleanup_monitoring() {
    echo "🔍 Cleaning up monitoring test environment..."
    
    # Find environment files
    ENV_PATTERN="env-*monitoring*.env"
    ENV_FILES=$(ls ${ENV_PATTERN} 2>/dev/null || echo "")
    
    if [[ -n "$ENV_FILES" ]]; then
        for env_file in $ENV_FILES; do
            echo "📋 Processing environment: $env_file"
            source "$env_file"
            
            # Delete the Kind cluster if it exists
            if [[ -n "$CLUSTER_NAME" ]] && kind get clusters 2>/dev/null | grep -q "^${CLUSTER_NAME}$"; then
                echo "   🗑️  Deleting cluster: $CLUSTER_NAME"
                kind delete cluster --name "$CLUSTER_NAME"
            else
                echo "   ℹ️  Cluster not found: ${CLUSTER_NAME:-<not set>}"
            fi
            
            # Remove kubeconfig file
            if [[ -n "$KUBECONFIG" && -f "$KUBECONFIG" ]]; then
                echo "   🗑️  Removing kubeconfig: $KUBECONFIG"
                rm -f "$KUBECONFIG"
            fi
            
            # Remove environment file
            echo "   🗑️  Removing environment file: $env_file"
            rm -f "$env_file"
        done
    else
        echo "   ℹ️  No environment files found"
        
        # Try to clean up based on common patterns
        echo "   🔍 Looking for clusters with pattern: *module-monitoring*"
        for cluster in $(kind get clusters 2>/dev/null | grep "module-monitoring" || echo ""); do
            echo "   🗑️  Deleting cluster: $cluster"
            kind delete cluster --name "$cluster"
        done
    fi
}

# Run cleanup
cleanup_monitoring

# Clean up any remaining temporary files
echo "🧽 Removing temporary files..."
rm -f kubeconfig-e2e*

# Show remaining Kind clusters (if any)
echo "🔍 Remaining Kind clusters:"
CLUSTERS=$(kind get clusters 2>/dev/null || echo "")
if [[ -n "$CLUSTERS" ]]; then
    echo "$CLUSTERS" | sed 's/^/   /'
else
    echo "   No Kind clusters found"
fi

echo "✅ Cleanup completed successfully!"
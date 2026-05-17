#!/usr/bin/env bash
set -euo pipefail

echo "1. Nodes:"
kubectl get nodes -o wide

echo ""
echo "2. Node labels:"
kubectl get nodes --show-labels

echo ""
echo "3. GPU resources exposed to Kubernetes:"
kubectl describe nodes | grep -i "nvidia.com/gpu" || {
  echo "No nvidia.com/gpu found. GPU device plugin/operator may not be working."
}

echo ""
echo "4. NVIDIA/GPU-related pods:"
kubectl get pods -A | grep -E "nvidia|gpu|dcgm|device-plugin" || true

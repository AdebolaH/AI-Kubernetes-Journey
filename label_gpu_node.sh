#!/usr/bin/env bash
set -euo pipefail

GPU_NODE="${1:-}"

if [ -z "$GPU_NODE" ]; then
  echo "Usage: ./02-label-gpu-node.sh <gpu-node-name>"
  echo "Find node names with: kubectl get nodes"
  exit 1
fi

kubectl label node "$GPU_NODE" accelerator=nvidia --overwrite
kubectl label node "$GPU_NODE" workload=ai-inference --overwrite
kubectl label node "$GPU_NODE" gpu-tier=small --overwrite
kubectl label node "$GPU_NODE" environment=lab --overwrite

echo "Labels applied to $GPU_NODE"
kubectl get node "$GPU_NODE" --show-labels

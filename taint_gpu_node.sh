#!/usr/bin/env bash
set -euo pipefail

GPU_NODE="${1:-}"

if [ -z "$GPU_NODE" ]; then
  echo "Usage: ./03-taint-gpu-node.sh <gpu-node-name>"
  exit 1
fi

kubectl taint node "$GPU_NODE" nvidia.com/gpu=true:NoSchedule --overwrite

echo "Taint applied to $GPU_NODE"
kubectl describe node "$GPU_NODE" | grep -i taints -A2

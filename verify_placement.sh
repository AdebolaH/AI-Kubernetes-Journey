#!/usr/bin/env bash
set -euo pipefail

NS="ai-platform"
APP="vllm-qwen-small"

echo "1. Pod placement:"
kubectl get pods -n "$NS" -l app="$APP" -o wide

echo ""
echo "2. Pod scheduling events:"
POD="$(kubectl get pods -n "$NS" -l app="$APP" -o jsonpath='{.items[0].metadata.name}')"
kubectl describe pod "$POD" -n "$NS" | sed -n '/Events:/,$p'

echo ""
echo "3. Node selected by pod:"
NODE="$(kubectl get pod "$POD" -n "$NS" -o jsonpath='{.spec.nodeName}')"
echo "$NODE"

echo ""
echo "4. Node labels:"
kubectl get node "$NODE" --show-labels

echo ""
echo "5. Node taints:"
kubectl describe node "$NODE" | grep -i taints -A2

echo ""
echo "6. GPU allocatable resources:"
kubectl describe node "$NODE" | grep -i "nvidia.com/gpu" -A3 -B3 || true

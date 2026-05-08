#!/usr/bin/env bash
set -euo pipefail

NS="ai-platform"
APP="vllm-qwen-small"

echo "1. Pods"
kubectl get pods -n "$NS" -l app="$APP" -o wide

echo ""
echo "2. Deployment"
kubectl get deployment "$APP" -n "$NS" -o wide

echo ""
echo "3. Recent events"
kubectl get events -n "$NS" --sort-by=.lastTimestamp | tail -n 30

echo ""
echo "4. Pod description"
POD="$(kubectl get pods -n "$NS" -l app="$APP" -o jsonpath='{.items[0].metadata.name}')"
kubectl describe pod "$POD" -n "$NS"

echo ""
echo "5. Current logs"
kubectl logs "$POD" -n "$NS" --tail=100

echo ""
echo "6. Previous logs if container restarted"
kubectl logs "$POD" -n "$NS" --previous --tail=100 || true

echo ""
echo "7. GPU resources visible to Kubernetes"
kubectl describe nodes | grep -i "nvidia.com/gpu" || true

echo ""
echo "8. GPU Operator / device plugin / DCGM pods"
kubectl get pods -A | grep -E "gpu-operator|nvidia|device-plugin|dcgm" || true

echo ""
echo "9. Services"
kubectl get svc -n "$NS"

echo ""
echo "10. PVC"
kubectl get pvc -n "$NS"

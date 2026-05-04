#!/usr/bin/env bash

# Stop immediately if a command fails.
set -euo pipefail

echo "1. Checking Kubernetes access..."
kubectl cluster-info

echo ""
echo "2. Listing nodes..."
kubectl get nodes -o wide

echo ""
echo "3. Checking whether Kubernetes can see NVIDIA GPU resources..."
kubectl describe nodes | grep -i "nvidia.com/gpu" || true

echo ""
echo "4. Checking GPU Operator namespace..."
kubectl get ns | grep -E "gpu-operator|nvidia" || true

echo ""
echo "5. Checking GPU Operator pods..."
kubectl get pods -A | grep -E "gpu-operator|nvidia|dcgm|device-plugin" || true

echo ""
echo "6. Checking AI platform namespace..."
kubectl get ns ai-platform || kubectl create ns ai-platform

echo ""
echo "Pre-flight complete."

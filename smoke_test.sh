#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="ai-platform"
SERVICE="vllm-qwen-small"
LOCAL_PORT="8080"

echo "Starting port-forward..."
kubectl port-forward "svc/${SERVICE}" -n "${NAMESPACE}" "${LOCAL_PORT}:80" >/tmp/vllm-port-forward.log 2>&1 &
PF_PID=$!

cleanup() {
  kill "${PF_PID}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

sleep 5

echo "Checking health..."
curl -fsS "http://localhost:${LOCAL_PORT}/health"
echo ""

echo "Checking metrics endpoint..."
curl -fsS "http://localhost:${LOCAL_PORT}/metrics" | head -n 20
echo ""

echo "Sending chat completion request..."
curl -fsS "http://localhost:${LOCAL_PORT}/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen-small",
    "messages": [
      {
        "role": "user",
        "content": "Explain why GPU memory matters for LLM inference in one short paragraph."
      }
    ],
    "max_tokens": 120,
    "temperature": 0.2
  }' | jq

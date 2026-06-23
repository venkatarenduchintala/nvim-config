#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${1:-default}"

echo "Checking pods in namespace: ${NAMESPACE}"

pods=$(kubectl get pods -n "${NAMESPACE}" --no-headers 2>/dev/null | wc -l)

if [[ "${pods}" -eq 0 ]]; then
  echo "No pods found in ${NAMESPACE}"
  exit 1
fi

echo "Found ${pods} pod(s)"

for pod in $(kubectl get pods -n "${NAMESPACE}" -o jsonpath='{.items[*].metadata.name}'); do
  status=$(kubectl get pod "${pod}" -n "${NAMESPACE}" -o jsonpath='{.status.phase}')
  echo "  ${pod}: ${status}"
done

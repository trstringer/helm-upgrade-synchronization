#!/bin/bash

CLUSTER_PREFIX="$1"
if [[ -z "$CLUSTER_PREFIX" ]]; then
    echo "./cluster_create.sh <cluster_prefix>"
    exit 1
fi

RESOURCE_NAME="${CLUSTER_PREFIX}${RANDOM}"

echo "$(date) - Using resource name '$RESOURCE_NAME'"

az group create \
    -l eastus \
    -n "$RESOURCE_NAME"
az aks create \
    -n "$RESOURCE_NAME" \
    -g "$RESOURCE_NAME" \
    --node-count 1

az aks get-credentials \
    -n "$RESOURCE_NAME" \
    -g "$RESOURCE_NAME" \
    --overwrite-existing

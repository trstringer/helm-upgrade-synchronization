#!/bin/bash

TAG=$(git rev-parse --short HEAD)
TIMEOUT="30m"

helm upgrade \
    --install \
    --set imageTag=$TAG \
    --timeout "$TIMEOUT" \
    long-op-app app-chart

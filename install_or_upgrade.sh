#!/bin/bash

TAG=$(git rev-parse --short HEAD)

helm upgrade \
    --install \
    --set imageTag=$TAG \
    long-op-app app-chart

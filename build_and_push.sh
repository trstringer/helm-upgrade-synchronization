#!/bin/bash

TAG=$(git rev-parse --short HEAD)

docker build -t trstringer/long-op-upgrade-all:$TAG ./app
docker build -t trstringer/long-op-upgrade-pre-upgrade:$TAG ./pre-upgrade

docker push trstringer/long-op-upgrade-app:$TAG
docker push trstringer/long-op-upgrade-pre-upgrade:$TAG

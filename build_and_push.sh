#!/bin/bash

docker build -t trstringer/long-op-upgrade:latest ./app
docker build -t trstringer/long-op-upgrade-pre-upgrade:latest ./pre-upgrade

docker push trstringer/long-op-upgrade:latest
docker push trstringer/long-op-upgrade-pre-upgrade:latest

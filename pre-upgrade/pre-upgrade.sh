#!/bin/bash

APP_SVC="$1"

if [[ -z "$APP_SVC" ]]; then
    echo "You must specify the app svc hostname or IP"
    exit 1
fi

echo "$(date) - Checking to see if the application is upgradeable"

while true; do
    IS_UPGRADEABLE=$(curl -s "${APP_SVC}/upgradeable" |
        python3 -c 'import sys, json; print(json.load(sys.stdin)["isUpgradeable"])' |
        tr '[:upper:]' '[:lower:]')
    echo "$(date) - Is upgradeable: $IS_UPGRADEABLE"

    if [[ "$IS_UPGRADEABLE" == "true" ]]; then
        echo "$(date) - Cluster is upgradeable"
        break
    fi

    sleep 10
done

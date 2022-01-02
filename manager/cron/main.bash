#!/bin/bash

set -e

__dirname="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

function getHash() {
    printf "%s" "$(git ls-remote "https://github.com/talentmaker/$1.git" | grep "refs/heads/master" | awk "{print \$1}")"

    return 0
}

siteHash="$(getHash "site")"
apiHash="$(getHash "api")"

changed="$(python3 "${__dirname}/compareHash.py" --api="$apiHash" --site="$siteHash")"

if [[ "$changed" == "" ]]; then
    echo "No changes detected, skipping build and restart."

    exit 0
else
    docker-compose build --build-arg API_HASH="$apiHash" --build-arg SITE_HASH="$siteHash"

    systemctl restart talentmaker
fi

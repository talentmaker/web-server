#!/bin/bash

set -o pipefail -e

__dirname="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
source "${__dirname}/../utils.bash"

function getHash() {
    printf "%s" "$(git ls-remote "https://github.com/talentmaker/$1.git" | grep "refs/heads/master" | awk "{print \$1}")"

    return 0
}

siteHash="$(getHash "site")"
apiHash="$(getHash "api")"

changed="$(python3 "${__dirname}/compareHash.py" --api="$apiHash" --site="$siteHash")"

if [[ "$changed" == "0" ]]; then
    exit 0
else
    docker-compose build --build-arg API_HASH="$apiHash" --build-arg SITE_HASH="$siteHash" 2>&1 | log "build"

    sudo systemctl restart talentmaker 2>&1 | log "build"

    sendEmail "$(printf "$(cat "${__dirname}/buildSuccess.json")" "$(date)")" 2>&1 | log "build"
fi

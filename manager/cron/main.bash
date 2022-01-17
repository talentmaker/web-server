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

if [[ "$changed" == "" ]]; then
    exit 0
else
    if [[ "$changed" == *"api"* ]]; then
        cd /tmp

        if [[ -d ./talentmaker-api ]]; then
            cd ./talentmaker-api

            git pull origin master \
                || cd .. \
                    && rm -rf talentmaker-api \
                    && git clone git@github.com:talentmaker/api.git talentmaker-api \
                    && cd ./talentmaker-api
        else
            git clone git@github.com:talentmaker/api.git talentmaker-api

            cd ./talentmaker-api
        fi

        echo "$(cat "${__dirname}/../../api/encryption-key.txt")" | gpg --batch --yes --passphrase-fd 0 --output ./.env --decrypt ./.env.gpg

        pnpm install --dev
        pnpm prismaGenerate
        pnpm prisma migrate deploy

        cd "$__dirname"
    fi

    docker-compose -f "${__dirname}/../../docker-compose.yml" build --build-arg API_HASH="$apiHash" --build-arg SITE_HASH="$siteHash"

    sudo systemctl restart talentmaker

    sendEmail "$(printf "$(cat "${__dirname}/buildSuccess.json")" "$(date)")"
fi

#!/bin/bash

set -o pipefail -o xtrace

__dirname="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
source "${__dirname}/utils.bash"

"${__dirname}/cron/main.bash" 2>&1 | log "build" true
exitStatus="$?"

echo -e "Exit status: $exitStatus" | log "build"

if [[ "$exitStatus" != "0" ]]; then
    formattedLogs="$(tail -30 "${__dirname}/logs/build.log" | python -c 'import json, sys; print(json.dumps(sys.stdin.read()))' | sed -e 's/^"//' -e 's/"$//')"

    sendEmail "$(printf "$(cat "${__dirname}/cron/buildError.json")" "$(date)" "$formattedLogs")" 2>&1 | log "build" true
fi

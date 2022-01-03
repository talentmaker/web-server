#!/bin/bash

__dirname="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
source "${__dirname}/../utils.bash"

serviceResult="$1"
exitCode="$2"
exitStatus="$3"

printf "App exited\n    Result: %s\n    Exit code: %s\n    Exit status: %s\n" "$serviceResult" "$exitCode" "$exitStatus" | log "app"

if [[ "$exitStatus" != "0" ]]; then
    logs="$(sudo journalctl -u talentmaker -n 30 --no-pager | python -c 'import json, sys; print(json.dumps(sys.stdin.read()))' | sed -e 's/^"//' -e 's/"$//')"

    sendEmail "$(printf "$(cat "${__dirname}/appError.json")" "$exitStatus" "$(date)" "$serviceResult" "$exitCode" "$exitStatus" "$logs")" 2>&1 | log "app"
fi

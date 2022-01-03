#!/bin/bash

__dirname="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
source "${__dirname}/../utils.bash"

echo "App started" | log "app"

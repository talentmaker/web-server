#!/bin/sh

sendEmail() {
    /usr/local/bin/aws lambda invoke --function-name "lambda-ses" --payload "$1" /dev/stdout 2>&1
}

addDate() {
    while IFS= read -r line; do
        printf "%s | %s\n" "$(date +"%b %e %H:%M:%S %Z $(hostname)")" "$line";
    done
}

# NOTE: All logs must have a trailing newline
log() {
    __dirname="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"

    while IFS= read -r line; do
        printf "%s\n" "$line" | sed 's/\x1b\[[0-9;]*m//g' | addDate >> "${__dirname}/logs/${1}.log"
    done
}

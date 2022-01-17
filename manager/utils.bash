#!/bin/sh

sendEmail() {
    /usr/local/bin/aws lambda invoke --function-name "lambda-ses" --payload "$1" /dev/stdout 2>&1
}

addDate() {
    while IFS= read -r line; do
        printf "%s | %s\n" "$(date +"%b %e %H:%M:%S %Z $(hostname)")" "$line";
    done
}

# Log logs stdin to a log file in ./logs
# NOTE: All logs must have a trailing newline
# PARAMS:
#     1 - fileName - required - filename of log
#     2 - quiet - optional - if true, logs will not be printed to stdout - default false
log() {
    __dirname="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
    output=""

    while IFS= read -r line; do
        printf "%s\n" "$line" | sed 's/\x1b\[[0-9;]*m//g' | addDate >> "${__dirname}/logs/${1}.log"
        output="${output}${line}\n"
    done

    if ! [[ "${2}" ]]; then
        echo -e "$output"
    fi
}

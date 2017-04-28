#! /usr/bin/env bash
set -eu

git --version     > /dev/null
ansible --version > /dev/null
vagrant --version > /dev/null
vboxmanage -v     > /dev/null
packer version    > /dev/null

test -e http
LOG_USER="${USER:-packer_build}";  export LOG_USER
LOG_FILE="logs/$(date "+%y%m%d").log"; export LOG_FILE

function set_log(){
    LOG_FILE="$1"
    export LOG_FILE
}

function log(){
    # TODO: make color changes based on first argument

    # Just simple log "msg"
    if [[ "$#" -eq 1 ]]; then
        echo "$1" | tee "${LOG_FILE}"
        logger -t "${LOG_USER}" "INFO: $1"
    fi
    # More complicated log "severity" "msg"
    if [[ "$#" -eq 2 ]]; then
        echo "$1" "$2" | tee "${LOG_FILE}"
        logger -t "${LOG_USER}" "$1:" "$2"
    fi
    # Supah fancy log "severity" "msg" "filename"
    if [[ "$#" -eq 3 ]]; then
        test -e "$3" || return
        echo "$1:" "$2" | tee "$3"
        logger -t "${LOG_USER}" "$1:" "$2"
    fi
}

function graceful_exit(){
    [[ -z $@ ]] && exit 0
    log "ERROR" "$1"
    exit 1
}


if [[ $(find iso -name "*.iso" | wc -l) == 0 ]]; then
    log "WARNING" "No ISOs found for some reason"
fi

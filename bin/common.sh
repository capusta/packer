#! /usr/bin/env bash
set -eu

# TODO: check a specific version
git --version     > /dev/null
ansible --version > /dev/null
vboxmanage -v     > /dev/null
packer version    > /dev/null

test -e ./http
LOG_USER='packer_build'

function graceful_exit(){
    [[ -z $@ ]] && exit 0
    echo $1
    logger -t ${LOG_USER} "ERROR: $1"
    exit 1
}

function log(){
    # TODO: make color changes based on first argument
    echo $1
    logger -t ${LOG_USER} "INFO: $1"
}

if [[ $(find iso -name *.iso | wc -l) == 0 ]]; then
    log "No ISOs found for some reason"
fi

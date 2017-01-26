#! /usr/bin/env bash
set -eu

# Call yourself with -h if no arguments
[[ -z $@ ]] && ./$0 -h && exit 1

while [[ $# -ge 1 ]]; do
    key="$1"
    case $key in
        -h|--help)
            echo -e "
            Usage:
            -h|--help \t\t Bring up this menu
            -n|--name \t\t Hostname
            --os (centos|ubuntu) \t Type of OS
            "
            exit
        ;;
    -n|--name)
        HOSTNAME=$2
        shift; shift;
        ;;
    esac
done

# Going to assume that no one is going to be running
# anything directly out of this folder
source bin/common.sh

# Sanity check
if [[ -z ${HOSTNAME+x} ]]; then
    graceful_exit "Hostname not defined"
fi
log "Building: ${HOSTNAME}"

# Shared Vars setup ... for customization
SHARED_VARS=''
# Packer will dump the final product here
output_directory="vm_out"
test -e ${output_directory}

SHARED_vars="${SHARED_VARS}
                -var output_directory=${output_directory}
                -var hostname=${HOSTNAME}"

packer validate ${SHARED_VARS} ubuntu.json
packer build -force ${SHARED_VARS} ubuntu.json


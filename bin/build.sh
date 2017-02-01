#! /usr/bin/env bash
set -eu

##Parse long and short OPTIONS
OPTIONS=$(getopt -o hn: -l name:,os:,download:,help -- "$@")

if [ $? != 0 ]; then
    echo "Failed to parse arguments."
    exit 1
fi

# Call yourself with -h if no arguments
[[ -z $@ ]] && $0 -h && exit 1

eval set -- "$OPTIONS"
while true; do
    case "$1" in
        -h|--help)
            echo -e "
            Usage:
            -h|--help \t\t Bring up this menu
            -n|--name \t\t Hostname
            --os (centos|ubuntu) \t Type of OS
            --download \t Downloads the ISOs from internetz
            "
            exit
            ;;
        -n|--name)
            HOST=$2
            shift; shift;
            ;;
        --os)
            OS=$2
            shift; shift
            ;;
        --download)
            DOWNLOAD=$2
            shift; shift;
            ;;
        --)
            shift;
            break
            ;;
    esac
done

if [[ ! -z ${DOWNLOAD:-} ]]; then
    bin/download.sh --os "${DOWNLOAD}"
    exit 0
fi

# Load good common libraries ... like logging, etc
source bin/common.sh || true

# Sanity check
if [[ -z ${HOST:-} ]]; then
    graceful_exit "Hostname not defined"
fi

if [[ -z ${OS:-} ]]; then
    graceful_exit "Operating System not defined"
fi

set_log "logs/${HOST}-${OS}.log"
log "INFO" "Building: ${OS} ${HOST}"

# Packer will dump the final product here
output_directory="vm_out"
test -e ${output_directory}

SHARED_VARS="-var hostname=${HOST}"
SHARED_VARS="${SHARED_VARS} -var output_directory=${output_directory}"

log "Validating ${SHARED_VARS}"
packer validate $SHARED_VARS ubuntu.json

log "Settings validated: ${SHARED_VARS}"
log "Starting building ${OS} ${HOST}"

packer build -force $SHARED_VARS ubuntu.json >> "${LOG_FILE}"


#! /usr/bin/env bash
set -eu

# Downloads ISO from internetz
OPTIONS=$(getopt -o hn: -l os:,codename:,help: -- "$@")
source bin/common.sh

if [ $? != 0 ]; then
    graceful_exit 'Failed to parse arguments'
fi
#Call yourself with -h if no arguments
[[ -z $@ ]] && $0 -h && exit 1

set +x

eval set -- "$OPTIONS"
while true; do
    case "$1" in
		-h|--help)
			echo -e "
			Usage:
			--os \t (ubuntu|centos) Maybe we will be more specific later
			--codename \t (trusty|xenial|6.7|7.2)
			"
			shift;
			exit 0
			;;
        --os)
			case $2 in
				ubuntu)
					OS='http://releases.ubuntu.com/16.04/ubuntu-16.04.1-server-amd64.iso'
					;;
				centos)
					OS='http://mirror.atlantic.net/centos/7/isos/x86_64/CentOS-7-x86_64-Everything-1611.iso'
					;;
				*)
					graceful_exit "Invalid OS"
					;;
			esac
            shift; shift;
            ;;
		--codename)
			log "Codename Not implemented, but will be (trusty|xenial|7.2)"
			shift;
			;;
		--)
			shift;
			break
			;;
    esac
done

# Sanity check
if [[ -z ${OS+x} ]]; then
	graceful_exit "No OS given"
fi

log "Downloading ${OS}"
wget -N -P iso --progress=bar "${OS}"

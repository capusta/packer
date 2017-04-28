#! /bin/bash
set -e
grep -qi ubuntu /etc/issue && export OS=ubuntu || echo 'not ubuntu'

RED=`tput setaf 1`
GREEN=`tput setaf 2`
NC=`tput sgr0`

function out_ok {
    echo "${GREEN}$1${NC}"
    return
}

function out_err {
    echo "${RED}$1${NC}"
    return
}

case "${OS}" in
    ubuntu)
        echo "OS is ubuntu"
        out_ok "Checking Git"
        which git || sudo apt-get -y install git && out_ok "-->OK"
        out_ok "Checking vagrant"
        which vagrant || sudo apt-get -y install vagrant && out_ok "-->OK"
        out_ok "Checking virtualbox"
        which vboxmanage || sudo apt-get -y install virtualbox && out_ok "-->OK"
        ;;
    *)
        echo "Unknown OS"
        exit 1
        ;;
esac

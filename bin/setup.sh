#! /bin/bash
set -e
grep -qi ubuntu /etc/issue && export OS=ubuntu || echo 'not ubuntu'

RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
NC=`tput sgr0`

function out_ok {
    echo "${GREEN}$1${NC}"
    return
}

function out_err {
    echo "${RED}$1${NC}"
    return
}

function out_warn {
    echo "${YELLOW}$1${NC}"
    return
}
function install_packer {
    out_warn "Installing packer"
    p_v='1.0.4'
    wget -c -v https://releases.hashicorp.com/packer/${p_v}/packer_${p_v}_linux_amd64.zip
    unzip packer_${p_v}_linux_amd64.zip
    rm packer_${p_v}_linux_amd64.zip
    mv packer bin/ -fv
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
        out_warn "Checking packer"
        bin/packer -version || install_packer && out_ok "-->OK"
        out_warn "Checking ansible"
        ansible -version || sudo apt-get -y install ansible && out_ok "-->OK"
        ;;
    *)
        echo "Unknown OS"
        exit 1
        ;;
esac

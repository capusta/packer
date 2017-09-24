#! /bin/bash

set -eux

cd $HOME/.ssh/
cp id_rsa.pub authorized_keys
ls -lah


case "$PACKER_BUILDER_TYPE" in
virtualbox-iso|virtualbox-ovf)
    mkdir -p /tmp/vbox;
    mount -o loop $HOME/VBoxGuestAdditions.iso /tmp/vbox;
    sh /tmp/vbox/VBoxLinuxAdditions.run \
        || echo "VBoxLinuxAdditions.run exited $? and is suppressed." \
            "For more read https://www.virtualbox.org/ticket/12479";
    umount /tmp/vbox;
    rm -rf /tmp/vbox;
    rm -f $HOME/*.iso;
    ;;
esac

# Install ansible for further provisioning
apt-get install software-properties-common && \
apt-add-repository ppa:ansible/ansible && \
apt-get update && \
apt-get -y install ansible python-pip
pip install docker-py python-consul
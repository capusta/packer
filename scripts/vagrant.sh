#!/usr/bin/env bash

mkdir /home/vagrant/.ssh
wget --no-check-certificate -O authorized_keys 'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub'
mv authorized_keys /home/vagrant/.ssh
chown -R vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh

echo "==> Passwordless sudo for ${SSH_USERNAME}"
echo "${SSH_USERNAME}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
chmod 440 /etc/sudoers.d/vagrant

#!/usr/bin/env bash

echo "==> Remove all linux kernels except the current one"
dpkg --list | awk '{ print $2 }' | grep 'linux-image-4.*-generic' | grep -v $(uname -r) | xargs apt-get -y purge

apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean

dd if=/dev/zero of=/junk bs=1M
rm -f /junk

sync

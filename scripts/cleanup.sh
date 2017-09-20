#!/bin/bash -eux

# Not sure if we are going to run this or not
#dpkg --list | awk '{ print $2 }' | grep 'linux-image-4.*-generic' | grep -v $(uname -r) | xargs apt-get -y purge

apt-get -y autoremove --purge
apt-get -y autoclean
apt-get -y clean

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=16M || echo "dd exit code $? suppressed";
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

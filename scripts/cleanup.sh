#!/bin/bash -eux

rm -v /root/.ssh/id_rsa
rm -v /root/.ssh/id_rsa.pub
rm -v /root/.ssh/authorized_keys

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync

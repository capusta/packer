#d-i partman-auto-lvm/no_boot            boolean true
#d-i debian-installer/language string en
d-i debian-installer/locale string en_US
#d-i	localechooser/continentlist	select	North America
#d-i mirror/country string US
#d-i debian-installer/country string United States

d-i passwd/make-user boolean false
#d-i passwd/user-fullname string Ansible User
#d-i passwd/username string ansible
#d-i passwd/user-password password ansible
#d-i passwd/user-password-again password ansible
d-i user-setup/allow-password-weak boolean true
d-i passwd/user-default-groups string sudo


# Root password, either in clear text
d-i passwd/root-password password ansible
d-i passwd/root-password-again password ansible
d-i passwd/root-login boolean true

# Clock
d-i clock-setup/utc-auto boolean true
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true

d-i partman/default_filesystem string xfs
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string lvm
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-lvm/confirm boolean true
d-i partman/confirm                     boolean true
d-i partman-md/confirm                  boolean true
d-i partman-auto/purge_lvm_from_device  boolean true

d-i user-setup/encrypt-home boolean false
d-i partman-auto/choose_recipe select boot-crypto
d-i partman-auto-lvm/new_vg_name string lvm
d-i partman-auto-lvm/guided_size string max
d-i partman-auto/expert_recipe string boot-crypto :: \
        10000 20000 30000 xfs $lvmok{ } lv_name{ root } \
        in_vg { crypt } method{ format } format{ } \
        use_filesystem{ } filesystem{ xfs } mountpoint{ / } \
        . \
        500 750 1000 ext4 $primary{ } $bootable{ } \
        method{ format } format{ } \
        use_filesystem{ } filesystem{ ext4 } \
        mountpoint{ /boot } \
        .   \
        100% 200% 300% linux-swap $lvmok{ } lv_name{ swap } \
        in_vg { crypt } method{ swap } format{ } \
        .       \
        13000 35000 1000000000 xfs $lvmok{ } lv_name{ home } \
        use_filesystem{ } filesystem{ xfs } mountpoint{ /opt} \
        .   \
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman-md/confirm_nooverwrite boolean true
d-i partman-lvm/confirm_nooverwrite boolean true

# No proxy
d-i mirror/http/proxy string
# No auto updates
d-i pkgsel/update-policy select none

# No package upgrades
d-i pkgsel/upgrade select none

# Do not configure any apt repos
#d-i apt-setup/restricted boolean false
#d-i apt-setup/universe boolean fase
#d-i apt-setup/backports boolean false

# Uncomment this if you don't want to use a network mirror.
d-i apt-setup/use_mirror boolean false

# Just install common tools
tasksel tasksel/first multiselect server, openssh-server

# Just stand up an ssh server for now
d-i pkgsel/include string openssh-server build-essential

# Grub
d-i grub-installer/grub2_instead_of_grub_legacy boolean true
d-i grub-installer/only_debian boolean true
#d-i grub-installer/with_other_os boolean true
d-i finish-install/reboot_in_progress note
d-i preseed/late_command string \
in-target sed -i 's/PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config

#d-i preseed/late_command string sh -c 'echo ansible ALL=(ALL:ALL) NOPASSWD:ALL > /target/etc/sudoers.d/ansible'

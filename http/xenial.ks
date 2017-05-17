choose-mirror-bin mirror/http/proxy string
d-i base-installer/kernel/override-image string linux-server
d-i clock-setup/utc boolean true
d-i clock-setup/utc-auto boolean true
d-i console-setup/ask_detect boolean false
d-i debconf debconf/frontend select noninteractive
d-i finish-install/reboot_in_progress note
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i keyboard-configuration/layout select USA
d-i keyboard-configuration/variant select USA
d-i localechooser/preferred-locale string en_US.UTF-8
d-i partman-auto-lvm/guided_size string max
d-i partman-auto/choose_recipe select atomic
d-i partman-auto/method string lvm
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true
d-i partman/confirm_write_new_label boolean true
d-i passwd/user-uid string 900
d-i passwd/user-fullname string vagrant
d-i passwd/username string vagrant
d-i passwd/user-password password vagrant
d-i passwd/user-password-again password vagrant
d-i passwd/auto-login boolean true
d-i pkgsel/include string openssh-server cryptsetup build-essential libssl-dev libreadline-dev zlib1g-dev dkms nfs-common ntp curl linux-headers-$(uname -r) build-essential dkms lubuntu-desktop
d-i pkgsel/install-language-support boolean false
d-i pkgsel/update-policy select unattended-upgrades
d-i pkgsel/upgrade select safe-upgrade
d-i clock-setup/ntp boolean true
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false
d-i time/zone string America/Los_Angeles
tasksel tasksel/first multiselect standard, ubuntu-server

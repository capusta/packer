# Locale Setup
d-i debian-installer/language string en
d-i pkgsel/install-language-support boolean true
d-i debian-installer/locale string en_US.UTF-8
d-i debian-installer/splash boolean false

# Keyboard Setup
d-i console-setup/ask_detect boolean false
d-i keyboard-configuration/layoutcode string us
d-i keyboard-configuration/layout select USA
d-i keyboard-configuration/variant select USA


# Do not install additional software
d-i base-installer/install-recommends boolean false

# Clock Settings
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true
d-i time/zone string America/Los_Angeles

# Only ask the UTC question if there are other operating systems installed.
d-i clock-setup/utc-auto boolean true

# Network Setup
d-i netcfg/get_hostname string {{vm_name}}
d-i netcfg/get_domain string
# https://bugs.launchpad.net/ubuntu/+source/netcfg/+bug/713385
d-i netcfg/choose_interface select auto
# make sure you also add "interface=auto" to your boot command too
# https://bugs.launchpad.net/ubuntu/+source/netcfg/+bug/713385

d-i debconf debconf/frontend select noninteractive
d-i finish-install/reboot_in_progress note
d-i grub-installer/only_debian boolean true

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

# User Creation
d-i passwd/user-uid string 900
d-i passwd/user-fullname string vagrant
d-i passwd/username string vagrant
d-i passwd/user-password password vagrant
d-i passwd/user-password-again password vagrant
d-i passwd/auto-login boolean true
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false

# Package Selection
d-i pkgsel/include string openssh-server cryptsetup build-essential libssl-dev libreadline-dev \
zlib1g-dev dkms nfs-common ntp curl linux-headers-$(uname -r) build-essential dkms lubuntu-desktop
# Disable Proxy when downloading apt packages
d-i mirror/http/proxy string
d-i pkgsel/update-policy select unattended-upgrades
d-i pkgsel/upgrade select safe-upgrade
d-i hw-detect/load_firmware boolean false
d-i hw-detect/load_media boolean false
apt-cdrom-setup apt-setup/cdrom/set-first boolean false
tasksel tasksel/first multiselect

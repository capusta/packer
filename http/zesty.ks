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

# Disable Proxy when downloading apt packages
choose-mirror-bin mirror/http/proxy string

# Do not install additional software
d-i base-installer/install-recommends boolean false

# Install the server kernel
d-i base-installer/kernel/override-image string linux-server

# Clock Settings
d-i clock-setup/utc boolean true
d-i clock-setup/ntp boolean true
d-i time/zone string America/Los_Angeles

# Only ask the UTC question if there are other operating systems installed.
d-i clock-setup/utc-auto boolean true
d-i pkgsel/update-policy select unattended-upgrades
d-i pkgsel/upgrade select safe-upgrade
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false
tasksel tasksel/first multiselect standard, ubuntu-server

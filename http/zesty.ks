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


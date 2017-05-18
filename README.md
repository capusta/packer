[![Build Status](https://travis-ci.org/capusta/packer.svg?branch=master)](https://travis-ci.org/capusta/packer)

Run ./build -n hostname --os (ubuntu|centos)

##### Download the intial images
Ensure you have access to the internet:
```./bin/build.py --download --codename xenial```

##### Building Images
``` ./bin/build.py --codename xenial```

This is [Ubuntu](http://www.ubuntu.com/) [16.04 LTS](https://wiki.ubuntu.com/XenialXerus/ReleaseNotes) 64-bit server with [LXDE](http://lxde.org/) desktop ([lubuntu-desktop](http://packages.ubuntu.com/xenial/lubuntu-desktop)). 

Resources
---------

* My previous desktop base box: https://bitbucket.org/janihur/ubuntu-1404-server-vagrant
* http://wiki.lxde.org/en/Ubuntu
* [How to install Lubuntu Desktop Environment and ONLY the desktop environment?](http://askubuntu.com/q/243318/18928)
* [Appendix B. Automating the installation using preseeding](https://help.ubuntu.com/16.04/installation-guide/amd64/apb.html)
* http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html
* http://chef.github.io/bento/
* https://github.com/boxcutter/ubuntu
* https://github.com/geerlingguy/packer-ubuntu-1404
* https://bitbucket.org/ariya/packer-vagrant-linux/src

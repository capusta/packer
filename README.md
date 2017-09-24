[![Build Status](https://travis-ci.org/capusta/packer.svg?branch=master)](https://travis-ci.org/capusta/packer)

`bin/build.py --hostname hostname --os (ubuntu|centos) --codename zesty -u user`

For help:

`./bin/build.py`

##### Download the intial images
Ensure access to the internet:
```./bin/build.py --download --codename zesty```

##### Building Images
``` ./bin/build.py --codename zesty --hostname myVM -u myuser```

[Ubuntu](http://www.ubuntu.com/) [16.04 LTS](https://wiki.ubuntu.com/XenialXerus/ReleaseNotes) 64-bit server with [LXDE](http://lxde.org/) desktop ([lubuntu-desktop](http://packages.ubuntu.com/xenial/lubuntu-desktop)). 


###### Customizing with Ansible
```bash
export ANSIBLE_PLAYBOOK='kickstart.yml';
export ANSIBLE_EXTRA_ARGS='-Dvv -c local' &&
vagrant provision
```
Vagrant is going to try to find the $ANSIBLE_PLAYBOOK file in the current directory, if defined.  Default file is 
`entrypoint.yml` 

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

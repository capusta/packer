Ubuntu 16.04 Desktop Vagrant Base Box
=====================================

This is [Ubuntu](http://www.ubuntu.com/) [16.04 LTS](https://wiki.ubuntu.com/XenialXerus/ReleaseNotes) 64-bit server with [LXDE](http://lxde.org/) desktop ([lubuntu-desktop](http://packages.ubuntu.com/xenial/lubuntu-desktop)). The main motivation for the base box is to have a lightweight Linux desktop for my professional and private projects.

This repository is for [Packer](https://www.packer.io/) configuration that is used to build the base box. The actual base box that one can use is located in [Atlas](https://atlas.hashicorp.com/boxes/search):

https://atlas.hashicorp.com/janihur/boxes/ubuntu-1604-lxde-desktop

Usage
-----

Install Virtualbox and Vagrant. Drop in shell and say:

```
$ vagrant init
$ cat Vagrantfile
Vagrant.configure(2) do |config|
  config.vm.box = "janihur/ubuntu-1604-lxde-desktop"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end
end
$ vagrant up
```

Business as usual, except turn on the GUI with `vb.gui = true`.

Default user/password  is `vagrant/vagrant` with passwordless sudo.

The box defaults to 1GB RAM, US locale, US keyboard layout and UTC timezone. You might want to change those:

* change RAM: edit `vb.memory` value in the Vagrantfile
* change keyboard layout: http://askubuntu.com/a/237057/18928
* change timezone: https://help.ubuntu.com/community/UbuntuTime

How the box was made
--------------------

Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com/downloads.html) and [Packer](https://www.packer.io/downloads.html).

Run `packer`:

```
$ packer build ubuntu-1604-lxde-desktop.json
# register the local box file for testing
$ vagrant box add --name ubuntu-1604-lxde-desktop build/ubuntu-1604-lxde-desktop.box
```

The used Ubuntu 64-bit PC (AMD64) server install image is downloaded from http://releases.ubuntu.com/16.04/

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

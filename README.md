# IPv6 Segment Routing Vagrant box

This repository generates a Vagrant box with IPv6 Segment Routing support.
It packages a linux kernel with IPv6 Segment Routing support, iproute2 and nanonet.
Generated Vagrant boxes are available on the [Vagrant Cloud](https://app.vagrantup.com/segment-routing).

- The first step is to produce the kernel packages with `make deb-pkg` and place them in the **kernel/** folder. A valid kernel configuration file for Linux kernel v4.14 is provided in this folder.

- After that, run the following commands to produce and test the Vagrant box.
```bash
$ make
$ make test
```

# Required software

- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) with its extension pack
- [QEMU](https://www.qemu.org/)
- [Vagrant](https://www.vagrantup.com/)
- [Vagrant-libvirt plugin](https://github.com/vagrant-libvirt/vagrant-libvirt)

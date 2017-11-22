# IPv6 Segment Routing Vagrant box

This is a project generates a Vagrant box with IPv6 Segment Routing ready to use.
It packages a compatible SRv6 kernel, iproute2, nanonet.

- The first step is to produce the kernel packages with `make deb-pkg` and place them in the **kernel/** folder. A valid kernel configuration file for Linux kernel v4.14 is provided in this folder.

- After that, simply run the following commands to produce the Vagrant box.
```bash
$ make
$ make pack
```


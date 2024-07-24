About
This repository contains a terraform code to spin up an ubuntu vm using KVM/libvirt on Linux.

Prerequisite
1. Install packages on the hypervisor (Ubuntu) 
apt install -y terraform bridge-utils libvirt-clients libvirt-daemon qemu qemu-kvm whois xorriso

2. Create symlink for mkisofs as terrafrom provider (https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6) expects this but is not available. xorriso is emulating mkisofs.
ln -s /usr/bin/xorrisofs /usr/bin/mkisofs

3. Set the security_driver = "none" in /etc/libvirt/qemu.conf. This solved my issue with access to the vm images. (Not recommend in production setups)




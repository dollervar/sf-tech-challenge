About

This repository contains a terraform code to spin up an ubuntu vm using KVM/libvirt on Linux.

Prerequisite
1. Install packages on the hypervisor (Ubuntu) 
apt install -y terraform bridge-utils libvirt-clients libvirt-daemon qemu qemu-kvm whois xorriso

2. Create symlink for mkisofs as terrafrom provider (https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6) expects this but is not available. xorriso is emulating mkisofs.
ln -s /usr/bin/xorrisofs /usr/bin/mkisofs

3. Set the security_driver = "none" in /etc/libvirt/qemu.conf. This solved my issue with access to the vm images. (Not recommend in production setups)


Network:
I choose the range 192.168.178.0/24 as the public network. The vm will have direct access to the physical network. Th vm also uses this network to connect to the internet.
You will need t change the ext network variables in varibles.tf as well as in the ansible playbook.

Add a bridge to access exernal network
ip link add sfextbr0 type bridge

Add the physical NIC to the external bridge
ip link set <IF_NAME> master sfextbr0

Set address for the bridge interface
ip address add dev sfextbr0 192.168.178.190/24
ip link set <IF_NAME> up

RUN

terraform apply





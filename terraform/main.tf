terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

###############################################################################

resource "libvirt_pool" "ubuntu-terraform" {
  name = "ubuntu-terraform"
  type = "dir"
  path = "/var/lib/libvirt/terraform-provider-libvirt-pool-ubuntu-terraform"
}

resource "libvirt_volume" "ubuntu-vm-base" {
  name   = "ubuntu-vm-base"
  pool   = libvirt_pool.ubuntu-terraform.name
  source = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
  #source = "/var/lib/libvirt/terraform/base_images/ubuntu-24.04-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "ubuntu-vm" {
  name   = "ubuntu-vm"
  size	 = 1024 * 1024 * 1024 *10
  base_volume_id = libvirt_volume.ubuntu-vm-base.id
  pool   = libvirt_pool.ubuntu-terraform.name
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data	 = templatefile("${path.module}/templates/user_data.yaml", {
			hostname 	= var.hostname
			username 	= var.username
			password_hash	= var.user_password_hash
                        ssh_pub_key 	= var.user_ssh_pub_key
			})
  network_config = templatefile("${path.module}/templates/network_config.yaml", {
			ext_ip_addr	= var.ext_ip_addr
			ext_ip_netmask	= var.ext_ip_netmask
			ext_ip_gateway	= var.ext_ip_gateway
			int_ip_addr	= var.int_ip_addr
			int_ip_netmask	= var.int_ip_netmask
			})
  meta_data	 = templatefile("${path.module}/templates/meta_data.yaml", {
			hostname	= var.hostname
			})
  pool           = libvirt_pool.ubuntu-terraform.name
}
###############################################################################

resource "libvirt_network" "internal" {
  name           = "sf-internal"
  mode           = "bridge"
  bridge         = "sfbr0"
  autostart      = true
}

###############################################################################
# Create the machine
resource "libvirt_domain" "ubuntuvm" {
  name   = "ubuntuvm"
  memory = "512"
  vcpu   = 1
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    bridge 	 = "sfextbr0"
  }

  network_interface {
    network_name = "sf-internal"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
 
  disk {
    volume_id = libvirt_volume.ubuntu-vm.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

resource "proxmox_lxc" "container" {
  target_node  = var.target_node
  hostname     = var.hostname
  ostemplate   = var.ostemplate
  password     = var.password
  unprivileged = var.unprivileged

  # Defining the rootfs
  rootfs {
    storage = var.storage
    size    = var.rootfs_size
  }

  # Network configuration
  network {
    name   = "eth0"
    bridge = var.network_bridge
    ip     = "${var.ip_address}/${var.network_mask}"
    gw     = var.gateway
  }

  cores  = var.cores
  memory = var.memory
  swap   = var.swap

  tags = join(";", var.tags)
  
  ssh_public_keys = var.ssh_public_keys

  startup = var.startup
  onboot  = var.onboot
}
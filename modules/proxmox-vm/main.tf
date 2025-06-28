terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78.0"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name        = var.vm_name
  node_name   = var.target_node
  vm_id       = var.vm_id
  description = var.description
  tags        = var.tags
  
  # Clone configuration
  dynamic "clone" {
    for_each = var.template_name != null ? [1] : []
    content {
      vm_id = var.template_id
      full  = true
    }
  }
  
  # CPU configuration
  cpu {
    cores   = var.cores
    sockets = var.sockets
    type    = var.cpu_type
  }
  
  # Memory configuration
  memory {
    dedicated = var.memory
    floating  = var.memory  # Enable ballooning
  }
  
  # Boot configuration
  on_boot = var.on_boot
  started = var.started
  
  # Disk configuration
  disk {
    datastore_id = var.storage
    size         = var.disk_size
    interface    = "scsi0"
    discard      = "on"
    iothread     = true
  }
  
  # Network configuration
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }
  
  # Cloud-init configuration when using templates
  dynamic "initialization" {
    for_each = var.template_name != null ? [1] : []
    content {
      ip_config {
        ipv4 {
          address = "${var.ip_address}/${var.network_mask}"
          gateway = var.gateway
        }
      }
      
      user_account {
        username = var.ssh_username
        keys     = var.ssh_keys
        password = var.ssh_password
      }
    }
  }
  
  # Agent configuration
  agent {
    enabled = var.qemu_agent
    type    = "virtio"
  }
  
  # Operating system type
  operating_system {
    type = var.os_type
  }
}
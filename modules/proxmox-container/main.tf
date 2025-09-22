terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.84.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "container" {
  node_name   = var.target_node
  vm_id       = var.vm_id
  description = var.description
  tags        = var.tags
  
  # Container configuration
  unprivileged = var.unprivileged
  started      = var.started
  
  # Clone configuration
  dynamic "clone" {
    for_each = var.template_id != null ? [1] : []
    content {
      vm_id = var.template_id
    }
  }
  
  # CPU configuration
  cpu {
    cores = var.cores
    units = var.cpu_units
  }
  
  # Memory configuration
  memory {
    dedicated = var.memory
    swap      = var.swap
  }
  
  # Disk configuration
  disk {
    datastore_id = var.storage
    size         = var.rootfs_size
  }
  
  # Network configuration
  network_interface {
    name     = "eth0"
    bridge   = var.network_bridge
    firewall = var.firewall
  }
  
  # Operating system
  operating_system {
    template_file_id = var.ostemplate
    type            = var.os_type
  }
  
  # Initialization
  initialization {
    hostname = var.hostname
    
    dns {
      servers = var.dns_servers
      domain  = var.dns_domain
    }
    
    ip_config {
      ipv4 {
        address = var.ip_address != null ? "${var.ip_address}/${var.network_mask}" : "dhcp"
        gateway = var.gateway
      }
    }
    
    user_account {
      keys     = var.ssh_public_keys
      password = var.password
    }
  }
  
  # Features
  features {
    nesting = var.nesting
    fuse    = var.fuse
    keyctl  = var.keyctl
    mount   = var.mount_types
  }
  
  # Startup configuration
  dynamic "startup" {
    for_each = var.startup_order != null ? [1] : []
    content {
      order      = var.startup_order
      up_delay   = var.startup_up_delay
      down_delay = var.startup_down_delay
    }
  }
  
  start_on_boot = var.onboot
}
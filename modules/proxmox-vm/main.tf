terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  
  # Template configuration
  clone    = var.template_name
  os_type  = "cloud-init"
  boot     = "c"
  agent    = 1
  
  # Hardware configuration
  cores   = var.cores
  sockets = var.sockets
  memory  = var.memory
  
  # Disk configuration
  disk {
    slot     = 0
    size     = var.disk_size
    type     = "scsi"
    storage  = var.storage
    format   = "qcow2"
    iothread = 1
  }
  
  # Network configuration
  network {
    model  = "virtio"
    bridge = var.network_bridge
  }
  
  # Cloud-init configuration
  ipconfig0 = "ip=${var.ip_address}/${var.network_mask},gw=${var.gateway}"
  
  tags = join(";", var.tags)
}
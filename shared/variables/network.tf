variable "network_config" {
  description = "Network configuration by environment and provider"
  type = map(map(object({
    cidr_block     = string
    gateway        = string
    dns_servers    = list(string)
    network_bridge = string
  })))
  
  default = {
    development = {
      proxmox = {
        cidr_block     = "10.10.10.0/24"
        gateway        = "10.10.10.1"
        dns_servers    = ["10.10.10.1", "1.1.1.1"]
        network_bridge = "vmbr0"
      }
    }
    staging = {
      proxmox = {
        cidr_block     = "10.10.20.0/24"
        gateway        = "10.10.20.1"
        dns_servers    = ["10.10.20.1", "1.1.1.1"]
        network_bridge = "vmbr0"
      }
    }
    production = {
      proxmox = {
        cidr_block     = "10.10.30.0/24"
        gateway        = "10.10.30.1"
        dns_servers    = ["10.10.30.1", "8.8.8.8", "8.8.4.4"]
        network_bridge = "vmbr0"
      }
    }
  }
}

# Helper locals for easy access
locals {
  current_network = lookup(
    lookup(var.network_config, var.environment, {}),
    replace(var.provider_type, "-vm", ""),  # Handle proxmox-vm and proxmox-container
    null
  )
}
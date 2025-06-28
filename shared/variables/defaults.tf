# Default values for common infrastructure settings

locals {
  # Default VM/container sizes by environment
  default_sizes = {
    development = {
      cpu_cores      = 2
      memory_mb      = 2048
      disk_size_gb   = 20
      droplet_size   = "s-2vcpu-2gb"
    }
    staging = {
      cpu_cores      = 2
      memory_mb      = 4096
      disk_size_gb   = 40
      droplet_size   = "s-2vcpu-4gb"
    }
    production = {
      cpu_cores      = 4
      memory_mb      = 8192
      disk_size_gb   = 100
      droplet_size   = "s-4vcpu-8gb"
    }
  }
  
  # Default regions/locations
  default_locations = {
    digitalocean = {
      development = "nyc3"
      staging     = "nyc3"
      production  = "nyc1"
    }
    proxmox = {
      development = "pve"
      staging     = "pve"
      production  = "pve-prod"
    }
  }
  
  # Default images/templates
  default_images = {
    digitalocean = {
      ubuntu_2204 = "ubuntu-22-04-x64"
      ubuntu_2004 = "ubuntu-20-04-x64"
      debian_12   = "debian-12-x64"
    }
    proxmox_vm = {
      ubuntu_2204 = "ubuntu-22.04-cloudinit"
      ubuntu_2004 = "ubuntu-20.04-cloudinit"
      debian_12   = "debian-12-cloudinit"
    }
    proxmox_container = {
      ubuntu_2204 = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.gz"
      ubuntu_2004 = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
      debian_12   = "local:vztmpl/debian-12-standard_12.0-1_amd64.tar.gz"
    }
  }
}
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "droplet" {
  image      = var.droplet_image
  name       = var.droplet_name
  region     = var.droplet_region
  size       = var.droplet_size
  backups    = var.enable_backups
  monitoring = var.enable_monitoring
  ssh_keys = [
    var.ssh_fingerprint
  ]
  user_data = var.user_data_template != null ? templatefile(var.user_data_template, var.template_vars) : null

  tags = var.tags
}
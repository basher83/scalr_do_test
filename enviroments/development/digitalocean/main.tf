module "droplet" {
  source = "../../../modules/digitalocean-droplet"

  droplet_name      = var.droplet_name
  droplet_region    = var.droplet_region
  droplet_size      = var.droplet_size
  droplet_image     = var.droplet_image
  ssh_fingerprint   = var.ssh_fingerprint
  enable_backups    = false  # Usually disabled in development
  enable_monitoring = true
  
  user_data_template = "${path.module}/../../../modules/digitalocean-droplet/templates/cloud-init.tftpl"
  template_vars = {
    public_key = var.staging_public_key
  }
  
module "firewall" {
  source = "../../../modules/digitalocean-firewall"

  droplet_ids = [digitalocean_droplet.droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

  tags = local.common_tags
}

locals {
  common_tags = [
    "environment:development",
    "managed-by:terraform",
    "scalr-workspace:dev-digitalocean"
  ]
}
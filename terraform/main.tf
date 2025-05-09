terraform {
    required_providers {
        #scalr = {
        #    source  = "registry.scalr.io/scalr/scalr"
        #    version = "~> 2.0"
        #}
        digitalocean = {
            source  = "digitalocean/digitalocean"
            version = "~> 2.0"
        }
    }

  }



#provider "scalr" {
#  hostname = var.scalr_hostname
#  token    = var.scalr_token
#}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_droplet" "drop_test" {
  image      = var.droplet_image
  name       = var.droplet_name
  region     = var.droplet_region
  size       = var.droplet_size
  backups    = false
  monitoring = false
  ssh_keys = [
    var.ssh_fingerprint
  ]
  user_data = templatefile("${path.module}/digitalocean.tftpl", {
    public_key = var.staging_public_key
  })
  tags = ["yor-managed"]
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_fingerprint" {
  description = "Fingerprint of your SSH key in DigitalOcean"
  type        = string
  default     = "eb:54:57:c9:f7:9c:be:2b:4b:e1:69:41:89:d1:ea:b1"
  sensitive   = true
}

variable "droplet_image" {
  description = "Image identifier of the OS in DigitalOcean"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "droplet_name" {
  description = "Name of the DigitalOcean droplet"
  type        = string
  default     = "drop-test-v3"
}

variable "droplet_region" {
  description = "Droplet region identifier where the droplet will be created"
  type        = string
  default     = "nyc1"
}

variable "droplet_size" {
  description = "Droplet size identifier"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "staging_public_key" {
  description = "Public SSH key for Ansible user, provided via Scalr variable. Can also just be added via the UI."
  type        = string
  sensitive   = true
}

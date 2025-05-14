variable "droplet_name" {
  description = "Name of the DigitalOcean droplet"
  type        = string
  default     = "dev-droplet"
}

variable "droplet_region" {
  description = "Region for the droplet"
  type        = string
  default     = "nyc1"
}

variable "droplet_size" {
  description = "Size of the droplet"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "droplet_image" {
  description = "Image for the droplet"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "ssh_fingerprint" {
  description = "SSH key fingerprint"
  type        = string
  sensitive   = true
}

variable "staging_public_key" {
  description = "Public SSH key for Ansible user"
  type        = string
  sensitive   = true
}
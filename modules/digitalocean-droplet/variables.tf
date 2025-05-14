variable "droplet_name" {
  description = "Name of the DigitalOcean droplet"
  type        = string
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

variable "enable_backups" {
  description = "Enable backups for the droplet"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Enable monitoring for the droplet"
  type        = bool
  default     = true
}

variable "user_data_template" {
  description = "Path to cloud-init template file"
  type        = string
  default     = null
}

variable "template_vars" {
  description = "Variables to pass to the template"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the droplet"
  type        = list(string)
  default     = []
}
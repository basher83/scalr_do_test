variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
}

variable "droplet_ids" {
  description = "List of droplet IDs to apply the firewall to"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the firewall"
  type        = list(string)
  default     = []
}

# Common rule toggles
variable "allow_ssh" {
  description = "Allow SSH access"
  type        = bool
  default     = true
}

variable "allow_http" {
  description = "Allow HTTP access"
  type        = bool
  default     = true
}

variable "allow_https" {
  description = "Allow HTTPS access"
  type        = bool
  default     = true
}

variable "allow_icmp" {
  description = "Allow ICMP (ping)"
  type        = bool
  default     = true
}

# Source addresses for common rules
variable "ssh_sources" {
  description = "Source addresses allowed for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "http_sources" {
  description = "Source addresses allowed for HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "https_sources" {
  description = "Source addresses allowed for HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

variable "icmp_sources" {
  description = "Source addresses allowed for ICMP"
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
}

# Custom rules
variable "custom_inbound_rules" {
  description = "Custom inbound firewall rules"
  type = list(object({
    protocol         = string
    port_range       = string
    source_addresses = list(string)
  }))
  default = []
}

variable "custom_outbound_rules" {
  description = "Custom outbound firewall rules"
  type = list(object({
    protocol              = string
    port_range            = string
    destination_addresses = list(string)
  }))
  default = []
}
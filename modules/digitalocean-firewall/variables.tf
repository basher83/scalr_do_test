variable "firewall_name" {
  description = "Name of the firewall"
  type        = string
  default     = "default-firewall"
}

variable "droplet_ids" {
  description = "List of droplet IDs to apply firewall to"
  type        = list(string)
}

variable "inbound_rules" {
  description = "List of inbound firewall rules"
  type = list(object({
    protocol         = string
    port_range       = string
    source_addresses = list(string)
  }))
  default = []
}

variable "outbound_rules" {
  description = "List of outbound firewall rules"
  type = list(object({
    protocol              = string
    port_range            = string
    destination_addresses = list(string)
  }))
  default = []
}
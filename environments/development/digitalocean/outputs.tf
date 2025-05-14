output "droplet_ip" {
  value       = module.droplet.ipv4_address  # Reference module output
  description = "The public IPv4 address of the droplet"
}

output "droplet_id" {
  value       = module.droplet.id
  description = "The ID of the droplet"
}

output "firewall_id" {
  value       = module.firewall.id
  description = "The ID of the firewall"
}
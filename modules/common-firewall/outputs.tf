output "firewall_id" {
  description = "The ID of the firewall"
  value       = digitalocean_firewall.web.id
}

output "firewall_name" {
  description = "The name of the firewall"
  value       = digitalocean_firewall.web.name
}

output "firewall_status" {
  description = "The status of the firewall"
  value       = digitalocean_firewall.web.status
}

output "firewall_created_at" {
  description = "The creation timestamp of the firewall"
  value       = digitalocean_firewall.web.created_at
}
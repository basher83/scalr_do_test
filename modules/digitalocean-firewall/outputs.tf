output "id" {
  description = "The ID of the firewall"
  value       = digitalocean_firewall.firewall.id
}

output "status" {
  description = "The status of the firewall"
  value       = digitalocean_firewall.firewall.status
}
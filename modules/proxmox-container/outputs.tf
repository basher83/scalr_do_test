output "id" {
  description = "The ID of the container"
  value       = proxmox_lxc.container.id
}

output "hostname" {
  description = "The hostname of the container"
  value       = proxmox_lxc.container.hostname
}

output "ip_address" {
  description = "The IP address of the container"
  value       = "${var.ip_address}/${var.network_mask}"
}
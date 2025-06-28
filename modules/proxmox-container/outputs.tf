output "vm_id" {
  description = "The ID of the container"
  value       = proxmox_virtual_environment_container.container.vm_id
}

output "hostname" {
  description = "The hostname of the container"
  value       = var.hostname
}

output "ip_address" {
  description = "The IP address of the container"
  value       = var.ip_address != null ? "${var.ip_address}/${var.network_mask}" : "dhcp"
}

output "node_name" {
  description = "The node the container is running on"
  value       = proxmox_virtual_environment_container.container.node_name
}
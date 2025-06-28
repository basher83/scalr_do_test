output "vm_id" {
  description = "The ID of the VM"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

output "name" {
  description = "The name of the VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "ipv4_addresses" {
  description = "The IPv4 addresses published by QEMU agent"
  value       = proxmox_virtual_environment_vm.vm.ipv4_addresses
}

output "ipv6_addresses" {
  description = "The IPv6 addresses published by QEMU agent"
  value       = proxmox_virtual_environment_vm.vm.ipv6_addresses
}

output "mac_addresses" {
  description = "The MAC addresses of the VM"
  value       = proxmox_virtual_environment_vm.vm.mac_addresses
}

output "network_interface_names" {
  description = "The network interface names published by QEMU agent"
  value       = proxmox_virtual_environment_vm.vm.network_interface_names
}
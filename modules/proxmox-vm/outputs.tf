output "id" {
  description = "The ID of the VM"
  value       = proxmox_vm_qemu.vm.id
}

output "default_ipv4_address" {
  description = "The default IPv4 address of the VM"
  value       = proxmox_vm_qemu.vm.default_ipv4_address
}

output "ssh_host" {
  description = "The SSH host address"
  value       = proxmox_vm_qemu.vm.ssh_host
}

output "ssh_port" {
  description = "The SSH port"
  value       = proxmox_vm_qemu.vm.ssh_port
}
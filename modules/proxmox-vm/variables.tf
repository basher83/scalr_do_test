variable "vm_name" {
  description = "The name of the VM"
  type        = string
}

variable "target_node" {
  description = "The name of the Proxmox node to create the VM on"
  type        = string
}

variable "vm_id" {
  description = "The VM ID"
  type        = number
  default     = null
}

variable "description" {
  description = "VM description"
  type        = string
  default     = "Managed by Terraform"
}

variable "template_name" {
  description = "Name of the template to clone (optional)"
  type        = string
  default     = null
}

variable "template_id" {
  description = "VM ID of the template to clone"
  type        = number
  default     = null
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "CPU type (e.g., 'x86-64-v2-AES', 'host')"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}

variable "storage" {
  description = "Storage location for the VM disk"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ip_address" {
  description = "IP address for the VM (without CIDR notation)"
  type        = string
  default     = null
}

variable "network_mask" {
  description = "Network mask (e.g., 24 for /24)"
  type        = number
  default     = 24
}

variable "gateway" {
  description = "Gateway IP address"
  type        = string
  default     = null
}

variable "ssh_username" {
  description = "SSH username for cloud-init"
  type        = string
  default     = "ubuntu"
}

variable "ssh_keys" {
  description = "SSH public keys for cloud-init"
  type        = list(string)
  default     = []
}

variable "ssh_password" {
  description = "SSH password for cloud-init"
  type        = string
  default     = null
  sensitive   = true
}

variable "qemu_agent" {
  description = "Enable QEMU guest agent"
  type        = bool
  default     = true
}

variable "os_type" {
  description = "Operating system type (e.g., 'l26' for Linux 2.6+)"
  type        = string
  default     = "l26"
}

variable "on_boot" {
  description = "Start VM on boot"
  type        = bool
  default     = true
}

variable "started" {
  description = "Start VM after creation"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the VM"
  type        = list(string)
  default     = []
}
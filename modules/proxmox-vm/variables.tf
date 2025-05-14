variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "target_node" {
  description = "Target Proxmox node"
  type        = string
}

variable "template_name" {
  description = "Name of the template to clone"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Amount of memory in MB"
  type        = number
  default     = 1024
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = string
  default     = "20G"
}

variable "storage" {
  description = "Storage pool"
  type        = string
  default     = "local-lvm"
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ip_address" {
  description = "Static IP address"
  type        = string
}

variable "network_mask" {
  description = "Network mask (CIDR notation)"
  type        = string
  default     = "24"
}

variable "gateway" {
  description = "Network gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the VM"
  type        = list(string)
  default     = []
}
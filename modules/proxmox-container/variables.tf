variable "target_node" {
  description = "Target Proxmox node"
  type        = string
}

variable "hostname" {
  description = "Container hostname"
  type        = string
}

variable "ostemplate" {
  description = "OS template for the container"
  type        = string
}

variable "password" {
  description = "Container root password"
  type        = string
  sensitive   = true
}

variable "unprivileged" {
  description = "Whether to make the container unprivileged"
  type        = bool
  default     = true
}

variable "storage" {
  description = "Storage pool"
  type        = string
  default     = "local-lvm"
}

variable "rootfs_size" {
  description = "Root filesystem size"
  type        = string
  default     = "8G"
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

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Amount of memory in MB"
  type        = number
  default     = 512
}

variable "swap" {
  description = "Amount of swap in MB"
  type        = number
  default     = 512
}

variable "tags" {
  description = "Tags to apply to the container"
  type        = list(string)
  default     = []
}

variable "ssh_public_keys" {
  description = "SSH public keys"
  type        = string
  default     = ""
}

variable "startup" {
  description = "Startup order"
  type        = string
  default     = "order=1"
}

variable "onboot" {
  description = "Whether to start on boot"
  type        = bool
  default     = false
}
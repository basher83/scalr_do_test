variable "target_node" {
  description = "Target Proxmox node"
  type        = string
}

variable "vm_id" {
  description = "Container ID"
  type        = number
  default     = null
}

variable "hostname" {
  description = "Container hostname"
  type        = string
}

variable "description" {
  description = "Container description"
  type        = string
  default     = "Managed by Terraform"
}

variable "ostemplate" {
  description = "OS template for the container (e.g., 'local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.gz')"
  type        = string
}

variable "os_type" {
  description = "Operating system type (e.g., 'ubuntu', 'debian', 'alpine')"
  type        = string
  default     = "unmanaged"
}

variable "template_id" {
  description = "ID of container template to clone from"
  type        = number
  default     = null
}

variable "password" {
  description = "Container root password"
  type        = string
  sensitive   = true
  default     = null
}

variable "unprivileged" {
  description = "Whether to make the container unprivileged"
  type        = bool
  default     = true
}

variable "started" {
  description = "Whether to start the container"
  type        = bool
  default     = true
}

variable "storage" {
  description = "Storage pool"
  type        = string
  default     = "local-lvm"
}

variable "rootfs_size" {
  description = "Root filesystem size in GB"
  type        = number
  default     = 8
}

variable "network_bridge" {
  description = "Network bridge"
  type        = string
  default     = "vmbr0"
}

variable "ip_address" {
  description = "Static IP address (without CIDR notation)"
  type        = string
  default     = null
}

variable "network_mask" {
  description = "Network mask (e.g., 24 for /24)"
  type        = number
  default     = 24
}

variable "gateway" {
  description = "Network gateway"
  type        = string
  default     = null
}

variable "firewall" {
  description = "Enable firewall on network interface"
  type        = bool
  default     = false
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "cpu_units" {
  description = "CPU units (relative weight)"
  type        = number
  default     = 1024
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
  type        = list(string)
  default     = []
}

variable "dns_servers" {
  description = "DNS servers"
  type        = list(string)
  default     = null
}

variable "dns_domain" {
  description = "DNS domain"
  type        = string
  default     = null
}

variable "nesting" {
  description = "Enable nesting feature"
  type        = bool
  default     = false
}

variable "fuse" {
  description = "Enable FUSE mounts"
  type        = bool
  default     = false
}

variable "keyctl" {
  description = "Enable keyctl() system call"
  type        = bool
  default     = false
}

variable "mount_types" {
  description = "Allowed mount types"
  type        = list(string)
  default     = []
}

variable "startup_order" {
  description = "Startup order"
  type        = number
  default     = null
}

variable "startup_up_delay" {
  description = "Startup up delay in seconds"
  type        = number
  default     = null
}

variable "startup_down_delay" {
  description = "Startup down delay in seconds"
  type        = number
  default     = null
}

variable "onboot" {
  description = "Whether to start on boot"
  type        = bool
  default     = true
}
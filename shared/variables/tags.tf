variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production"
  }
}

variable "provider_type" {
  description = "Provider type (digitalocean, proxmox-vm, proxmox-container)"
  type        = string
  validation {
    condition     = contains(["digitalocean", "proxmox-vm", "proxmox-container"], var.provider_type)
    error_message = "Provider type must be one of: digitalocean, proxmox-vm, proxmox-container"
  }
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}

locals {
  # Base tags applied to all resources
  base_tags = {
    "managed-by"  = "terraform"
    "project"     = "scalr-infra"
    "environment" = var.environment
    "provider"    = var.provider_type
    "workspace"   = "${var.environment}-${var.provider_type}"
  }
  
  # Environment-specific tags
  env_tags = {
    development = {
      "cost-center" = "dev-ops"
      "auto-stop"   = "true"
    }
    staging = {
      "cost-center" = "qa"
      "auto-stop"   = "true"
    }
    production = {
      "cost-center" = "production"
      "auto-stop"   = "false"
      "critical"    = "true"
    }
  }
  
  # Merge all tags
  common_tags = merge(
    local.base_tags,
    lookup(local.env_tags, var.environment, {}),
    var.additional_tags
  )
  
  # Convert to list format for resources that need it (like Proxmox)
  common_tags_list = [for k, v in local.common_tags : "${k}:${v}"]
}
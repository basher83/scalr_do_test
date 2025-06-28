# This file makes the shared variables directory a module
# No resources are created, only variables and locals are exposed

terraform {
  required_version = ">= 1.5.0"
}

# Re-export computed values for easy access
output "common_tags" {
  description = "Common tags as a map"
  value       = local.common_tags
}

output "common_tags_list" {
  description = "Common tags as a list (for Proxmox)"
  value       = local.common_tags_list
}

output "default_size" {
  description = "Default size configuration for the environment"
  value       = lookup(local.default_sizes, var.environment, {})
}

output "default_location" {
  description = "Default location for the provider"
  value = lookup(
    lookup(local.default_locations, replace(var.provider_type, "-vm", ""), {}),
    var.environment,
    ""
  )
}

output "network_config" {
  description = "Network configuration for the environment"
  value       = local.current_network
}
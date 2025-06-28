# Repository Restructuring Guide for Scalr Integration

## Current Issues with Your Structure

Looking at your current setup, you have several areas that can be improved for better Scalr integration:

1. **Single workspace approach** - Your current `backend.tf` points to a single workspace "test-run" which doesn't scale for multiple deployment types
2. **Mixed variable declarations** - Variables are scattered in the main configuration file
3. **No modular structure** - Everything is in one configuration, making it hard to reuse components
4. **Provider inconsistency** - Variable names don't align (e.g., `do_token` vs `token` mentioned in README)

## Recommended Repository Structure

Here's a scalable structure that follows Scalr best practices:

```plaintext
scalr_do_test/
├── README.md
├── .gitignore
├── .github/
│   └── workflows/
│       └── auto-assign.yml
├── modules/                           # Reusable modules
│   ├── digitalocean-droplet/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   └── templates/
│   │       └── cloud-init.tftpl
│   ├── proxmox-vm/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── provider.tf
│   └── proxmox-container/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── provider.tf
├── environments/                      # Environment-specific configurations
│   ├── development/
│   │   ├── digitalocean/
│   │   │   ├── backend.tf
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── terraform.tfvars.example
│   │   ├── proxmox-vm/
│   │   │   ├── backend.tf
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   └── terraform.tfvars.example
│   │   └── proxmox-container/
│   │       ├── backend.tf
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       ├── outputs.tf
│   │       └── terraform.tfvars.example
│   ├── staging/
│   └── production/
├── shared/                           # Shared configurations and policies
│   ├── variables/
│   │   ├── global.tf
│   │   └── common-tags.tf
│   └── policies/
│       └── opa-policies/
└── hooks/
    └── tflint.sh
```

## Key Improvements

### 1. Modular Architecture

Create separate modules for each deployment type. Modules should be self-contained, bundling only the resources, variables, and providers they need. They should have a single purpose and never contain submodules.

### 2. Environment-Based Organization

Use Scalr environments to align with your deployment environments (development, staging, production). Each environment should be a logical grouping of Terraform workspaces that have a common set of policies, provider credentials, and teams assigned to it.

### 3. Multiple Workspaces per Environment

Each deployment type (DigitalOcean, Proxmox VM, Proxmox LXC) should have its own workspace within each environment. This provides better isolation and blast radius control.

## Implementation Steps

### Step 1: Create Modules

**DigitalOcean Module** (`modules/digitalocean-droplet/main.tf`):

```hcl
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "droplet" {
  image      = var.droplet_image
  name       = var.droplet_name
  region     = var.droplet_region
  size       = var.droplet_size
  backups    = var.enable_backups
  monitoring = var.enable_monitoring
  ssh_keys = [
    var.ssh_fingerprint
  ]
  user_data = var.user_data_template != null ? templatefile(var.user_data_template, var.template_vars) : null

  tags = var.tags
}
```

**Proxmox VM Module** (`modules/proxmox-vm/main.tf`):

```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  target_node = var.target_node
  
  # Template configuration
  clone    = var.template_name
  os_type  = "cloud-init"
  boot     = "c"
  agent    = 1
  
  # Hardware configuration
  cores   = var.cores
  sockets = var.sockets
  memory  = var.memory
  
  # Disk configuration
  disk {
    slot     = 0
    size     = var.disk_size
    type     = "scsi"
    storage  = var.storage
    format   = "qcow2"
    iothread = 1
  }
  
  # Network configuration
  network {
    model  = "virtio"
    bridge = var.network_bridge
  }
  
  # Cloud-init configuration
  ipconfig0 = "ip=${var.ip_address}/${var.network_mask},gw=${var.gateway}"
  
  tags = join(";", var.tags)
}
```

### Step 2: Configure Backends for Multiple Workspaces

**Development DigitalOcean** (`environments/development/digitalocean/backend.tf`):

```hcl
terraform {
  backend "remote" {
    hostname = "the-mothership.scalr.io"
    workspaces {
      name = "dev-digitalocean"
    }
  }
}
```

**Development Proxmox VM** (`environments/development/proxmox-vm/backend.tf`):

```hcl
terraform {
  backend "remote" {
    hostname = "the-mothership.scalr.io"
    workspaces {
      name = "dev-proxmox-vm"
    }
  }
}
```

### Step 3: Environment-Specific Main Files

**Development DigitalOcean** (`environments/development/digitalocean/main.tf`):

```hcl
module "droplet" {
  source = "../../../modules/digitalocean-droplet"

  droplet_name      = var.droplet_name
  droplet_region    = var.droplet_region
  droplet_size      = var.droplet_size
  droplet_image     = var.droplet_image
  ssh_fingerprint   = var.ssh_fingerprint
  enable_backups    = false  # Usually disabled in development
  enable_monitoring = true
  
  user_data_template = "${path.module}/../../../modules/digitalocean-droplet/templates/cloud-init.tftpl"
  template_vars = {
    public_key = var.staging_public_key
  }
  
  tags = local.common_tags
}

locals {
  common_tags = [
    "environment:development",
    "managed-by:terraform",
    "scalr-workspace:dev-digitalocean"
  ]
}
```

### Step 4: Variable Management Strategy

Use Scalr's inheritance model. Objects created at the account scope can be assigned and inherited by environments, and objects assigned to environments will be inherited by workspaces.

**Global Variables** (Set at Scalr Account Level):

- `scalr_hostname`
- Organization-wide tags
- Common networking ranges

**Environment Variables** (Set at Scalr Environment Level):

- `environment_name` (development/staging/production)
- Environment-specific tags
- Provider credentials (scoped by environment)

**Workspace Variables** (Set at Individual Workspace Level):

- Resource-specific configurations
- Instance names and sizes
- Provider-specific settings

### Step 5: Variable Definitions

**Module Variables** (`modules/digitalocean-droplet/variables.tf`):

```hcl
variable "droplet_name" {
  description = "Name of the DigitalOcean droplet"
  type        = string
}

variable "droplet_region" {
  description = "Region for the droplet"
  type        = string
  default     = "nyc1"
}

variable "droplet_size" {
  description = "Size of the droplet"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "droplet_image" {
  description = "Image for the droplet"
  type        = string
  default     = "ubuntu-24-04-x64"
}

variable "ssh_fingerprint" {
  description = "SSH key fingerprint"
  type        = string
  sensitive   = true
}

variable "enable_backups" {
  description = "Enable backups for the droplet"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Enable monitoring for the droplet"
  type        = bool
  default     = true
}

variable "user_data_template" {
  description = "Path to cloud-init template file"
  type        = string
  default     = null
}

variable "template_vars" {
  description = "Variables to pass to the template"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the droplet"
  type        = list(string)
  default     = []
}
```

## Migration Strategy

### Phase 1: Create Modules

1. Extract your current DigitalOcean configuration into a module
2. Test the module in your current workspace
3. Create the new directory structure

### Phase 2: Set Up New Workspaces

1. Create development environment workspaces in Scalr
2. Set up provider configurations in Scalr account scope
3. Configure environment-level variables

### Phase 3: Add Proxmox Support

1. Create Proxmox modules (VM and LXC)
2. Set up Proxmox provider configuration in Scalr
3. Create workspaces for Proxmox deployments

### Phase 4: Environment Expansion

1. Clone development structure for staging and production
2. Adjust variables and configurations for each environment
3. Set up proper RBAC in Scalr for different environments

## Scalr-Specific Best Practices

### 1. Use VCS-Driven Workspaces

Configure workspaces to automatically trigger plans on pull requests and applies on merges. This provides better collaboration and review processes.

### 2. Leverage Scalr Provider for Automation

```hcl
# Use Scalr provider to manage workspaces
resource "scalr_workspace" "digitalocean_dev" {
  name         = "dev-digitalocean"
  environment_id = scalr_environment.development.id
  
  vcs_repo {
    identifier = "your-org/scalr_do_test"
    branch     = "main"
    path       = "environments/development/digitalocean"
  }
  
  working_directory = "environments/development/digitalocean"
  auto_apply        = false
  terraform_version = "~> 1.5"
}
```

### 3. Implement Proper Tagging Strategy

- Environment tags for resource identification
- Cost allocation tags
- Ownership tags
- Scalr workspace identification tags

### 4. Use Variable Sets

Create variable sets in Scalr for:

- Common provider credentials
- Shared networking configurations
- Standard tags and labels

## Advanced Features

### 1. Policy as Code with OPA

Use Scalr's OPA integration to enforce standards across deployments:

```rego
package terraform.rules.tagging

required_tags := ["environment", "managed-by", "owner"]

deny[msg] {
  resource := input.planned_values.root_module.resources[_]
  resource.type == "digitalocean_droplet"
  not has_required_tags(resource.values.tags)
  msg := sprintf("Droplet %s is missing required tags", [resource.address])
}

has_required_tags(tags) {
  count([tag | tag := tags[_]; contains(tag, required_tags[_])]) == count(required_tags)
}
```

### 2. Cross-Provider Dependencies

Use Scalr's workspace outputs to share information between providers:

```hcl
# In DigitalOcean workspace output
output "network_info" {
  value = {
    gateway = digitalocean_droplet.droplet.ipv4_address
    region  = digitalocean_droplet.droplet.region
  }
}

# In Proxmox workspace, reference the output
data "scalr_current_workspace" "digitalocean" {
  name = "dev-digitalocean"
}

locals {
  do_network = data.scalr_current_workspace.digitalocean.outputs.network_info
}
```

## Benefits of This Structure

1. **Isolation**: Each deployment type has its own state file and workspace
2. **Reusability**: Modules can be used across environments
3. **Scalability**: Easy to add new environments or providers
4. **Maintainability**: Clear separation of concerns
5. **Collaboration**: Teams can work on different components independently
6. **Compliance**: Easy to apply different policies per environment

This structure aligns with Scalr's organizational model and inheritance patterns, enabling you to centralize administration while decentralizing operations, making it easier to scale your infrastructure management as your team and requirements grow.

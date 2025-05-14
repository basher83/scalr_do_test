# Scalr Multi-Provider Infrastructure

This repository contains Terraform configurations for deploying infrastructure across multiple providers (DigitalOcean and Proxmox) using Scalr for state management and workflow automation.

## Repository Structure

```
scalr_do_test/
├── modules/                     # Reusable Terraform modules
│   ├── digitalocean-droplet/   # DigitalOcean droplet module
│   ├── digitalocean-firewall/  # DigitalOcean firewall module
│   ├── proxmox-vm/            # Proxmox virtual machine module
│   └── proxmox-container/     # Proxmox LXC container module
├── environments/               # Environment-specific configurations
│   ├── development/           # Development environment
│   ├── staging/              # Staging environment
│   └── production/           # Production environment
├── shared/                   # Shared configurations
│   ├── variables/           # Global variables and tags
│   └── policies/           # OPA policies
└── hooks/                  # Pre/post hooks
```

## Getting Started

### Prerequisites

- Scalr account and workspace access
- Provider credentials configured in Scalr:
  - DigitalOcean API token
  - Proxmox credentials
- SSH keys registered with providers

### Deployment

Each environment and provider combination has its own Scalr workspace:

- `dev-digitalocean` - Development DigitalOcean resources
- `dev-proxmox-vm` - Development Proxmox VMs
- `dev-proxmox-container` - Development Proxmox containers
- (Similar patterns for staging and production)

### Variable Management

Variables are managed at different Scalr levels:

1. **Account Level**: Common settings like Scalr hostname
2. **Environment Level**: Environment-specific tags and credentials
3. **Workspace Level**: Resource-specific configurations

### Modules

Each module is designed to be reusable across environments:

- **digitalocean-droplet**: Creates DigitalOcean droplets with cloud-init
- **digitalocean-firewall**: Manages DigitalOcean firewall rules
- **proxmox-vm**: Creates Proxmox virtual machines
- **proxmox-container**: Creates Proxmox LXC containers

### Policies

OPA policies enforce standards:

- Required tagging on resources
- Workspace naming conventions
- Resource configuration validation

## Contributing

1. Make changes in feature branches
2. Test in development environment first
3. Use pull requests for review
4. Scalr will automatically plan/apply based on workspace configuration
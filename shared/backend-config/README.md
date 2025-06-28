# Backend Configuration

This directory contains shared backend configuration to reduce duplication across environments.

## Usage

Instead of duplicating the backend configuration in every environment, use partial configuration:

### 1. Update backend.tf in each environment

Replace the full backend configuration with:

```hcl
terraform {
  backend "remote" {
    # Configuration loaded from backend config file or CLI
  }
}
```

### 2. Initialize with backend config

When initializing, specify the workspace name:

```bash
# Using command line arguments
tofu init \
  -backend-config="hostname=the-mothership.scalr.io" \
  -backend-config="workspaces={name=\"development-digitalocean\"}"

# Or using a local config file
echo 'workspaces = { name = "development-digitalocean" }' > backend-local.hcl
tofu init \
  -backend-config=../../../shared/backend-config/backend.hcl.template \
  -backend-config=backend-local.hcl

# Or using environment variables
export TF_WORKSPACE="development-digitalocean"
tofu init -backend-config=../../../shared/backend-config/backend.hcl.template
```

### 3. Scalr Authentication

Set your Scalr API token:

```bash
export SCALR_TOKEN="your-scalr-api-token"
```

## Workspace Naming Convention

Workspaces follow the pattern: `{environment}-{provider}`

Examples:

- `development-digitalocean`
- `development-proxmox-vm`
- `development-proxmox-container`
- `staging-digitalocean`
- `production-proxmox-vm`

## Benefits

1. **DRY Principle**: Backend configuration is centralized
2. **Flexibility**: Easy to switch between environments
3. **Security**: API tokens are not stored in code
4. **Consistency**: Enforces naming conventions

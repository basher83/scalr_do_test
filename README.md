# scalr_do_test

Test repo for Scalr with DigitalOcean

## Overview

This repository contains Terraform configuration for deploying a DigitalOcean droplet and managing it through Scalr.

## Prerequisites

- Terraform v1.0 or later
- Scalr account
- DigitalOcean account with API token

## Scalr Integration

This project is configured to use Scalr as a backend for Terraform state management. The configuration includes:

- Remote backend configuration in `main.tf`
- Scalr backend configuration in `.scalr/backend.hcl`

## Getting Started

1. Create a `.scalr/backend.hcl` file with your Scalr credentials:

```hcl
hostname     = "scalr.io"  # Replace with your actual Scalr hostname
token        = "your-scalr-api-token"  # Replace with your Scalr API token
organization = "org-example"  # Replace with your Scalr organization
workspace    = "do-droplet-workspace"  # Replace with your desired workspace name
```

2. Initialize Terraform with the Scalr backend:

```
terraform init -backend-config=.scalr/backend.hcl
```

3. Create `terraform.tfvars` from the example file and add your variable values

```
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

4. Run Terraform through Scalr or locally:

```
terraform plan
terraform apply
```

## Variable Management

Consider using Scalr's variable management capabilities through their UI or API instead of local tfvars files for sensitive variables (`do_token`, `ssh_fingerprint`, etc.).

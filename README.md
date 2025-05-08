# scalr_do_test

Test repo for Scalr with DigitalOcean

## Overview

This repository contains Terraform configuration for deploying a DigitalOcean droplet and managing it through Scalr. The deployment includes a fully configured Ubuntu droplet with Docker and necessary tooling pre-installed.

## Prerequisites

- Terraform v1.0 or later
- Scalr account
- DigitalOcean account with API token

## Repository Structure

- `/terraform/backend.tf` - Scalr backend configuration
- `/terraform/main.tf` - Main Terraform configuration with provider settings and droplet resource
- `/terraform/digitalocean.tftpl` - Cloud-init template for droplet provisioning
- `/terraform/outputs.tf` - Output definitions (droplet IP address)
- `/terraform/terraform.tfvars.example` - Example variable definitions

## Scalr Integration

This project uses Scalr as a backend for Terraform state management and variable handling. The configuration includes:

- Remote backend configuration in `backend.tf`
- Provider configuration in `main.tf`

## Getting Started

1. Create a provider configuration on Scalr for DigitalOcean
2. Set up the `token` variable with your DigitalOcean API token in Scalr
3. Copy `terraform.tfvars.example` to `terraform.tfvars` and customize as needed
4. Run Terraform through Scalr to deploy resources

## Variable Management

The following variables are used in this project:

### Required variables

- `token`: DigitalOcean API token (sensitive) # This is configured via Provider configuration in Scalr
- `ssh_fingerprint`: SSH key fingerprint registered in DigitalOcean
- `staging_public_key`: SSH public key for the Ansible user
- `scalr_hostname`: Scalr hostname (default: "the-mothership.scalr.io")
- `scalr_token`: Scalr API token (sensitive)

### Optional variables (with defaults)

- `droplet_image`: Image identifier (default: "ubuntu-24-04-x64")
- `droplet_name`: Name of the droplet (default: "drop-test-v3")
- `droplet_region`: Region for deployment (default: "nyc1")
- `droplet_size`: Size of the droplet (default: "s-1vcpu-1gb")

## Droplet Configuration

The deployed droplet is configured with:

- Ubuntu 24.04
- Docker pre-installed
- Python 3 and pip3
- ZSH as the default shell
- An "ansible" user with sudo privileges for management
- SSH key-based authentication only (password auth disabled)

## Outputs

After successful deployment, the following outputs are available:

- `droplet_ip`: The public IPv4 address of the created droplet

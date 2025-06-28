# Common Firewall Module

This module provides a reusable firewall configuration for DigitalOcean droplets with common web server rules.

## Features

- Configurable common rules (SSH, HTTP, HTTPS, ICMP)
- Support for custom inbound and outbound rules
- Flexible source address configuration
- Tag-based firewall assignment

## Usage

### Basic Web Server Firewall

```hcl
module "web_firewall" {
  source = "../../../modules/common-firewall"
  
  firewall_name = "web-server-fw"
  droplet_ids   = [module.web_droplet.id]
  
  # Use defaults: allow SSH, HTTP, HTTPS, ICMP from anywhere
}
```

### Restricted SSH Access

```hcl
module "secure_firewall" {
  source = "../../../modules/common-firewall"
  
  firewall_name = "secure-web-fw"
  droplet_ids   = [module.web_droplet.id]
  
  # Restrict SSH to specific IPs
  ssh_sources = ["10.0.0.0/8", "192.168.1.100/32"]
  
  # HTTP/HTTPS still open to all
  allow_http  = true
  allow_https = true
}
```

### Custom Application Ports

```hcl
module "app_firewall" {
  source = "../../../modules/common-firewall"
  
  firewall_name = "app-server-fw"
  droplet_ids   = [module.app_droplet.id]
  
  # Disable HTTP, keep HTTPS
  allow_http = false
  
  # Add custom application ports
  custom_inbound_rules = [
    {
      protocol         = "tcp"
      port_range       = "8080"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol         = "tcp"
      port_range       = "3000-3100"
      source_addresses = ["10.0.0.0/8"]
    }
  ]
}
```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| firewall_name | Name of the firewall | string | required |
| droplet_ids | List of droplet IDs to apply firewall to | list(string) | [] |
| tags | Tags to apply to the firewall | list(string) | [] |
| allow_ssh | Allow SSH access (port 22) | bool | true |
| allow_http | Allow HTTP access (port 80) | bool | true |
| allow_https | Allow HTTPS access (port 443) | bool | true |
| allow_icmp | Allow ICMP (ping) | bool | true |
| ssh_sources | Source addresses allowed for SSH | list(string) | ["0.0.0.0/0", "::/0"] |
| http_sources | Source addresses allowed for HTTP | list(string) | ["0.0.0.0/0", "::/0"] |
| https_sources | Source addresses allowed for HTTPS | list(string) | ["0.0.0.0/0", "::/0"] |
| icmp_sources | Source addresses allowed for ICMP | list(string) | ["0.0.0.0/0", "::/0"] |
| custom_inbound_rules | Custom inbound firewall rules | list(object) | [] |
| custom_outbound_rules | Custom outbound firewall rules | list(object) | [] |

## Outputs

| Name | Description |
|------|-------------|
| firewall_id | The ID of the firewall |
| firewall_name | The name of the firewall |
| firewall_status | The status of the firewall |
| firewall_created_at | The creation timestamp of the firewall |

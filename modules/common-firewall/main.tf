resource "digitalocean_firewall" "web" {
  name = var.firewall_name

  droplet_ids = var.droplet_ids

  # SSH access
  dynamic "inbound_rule" {
    for_each = var.allow_ssh ? [1] : []
    content {
      protocol         = "tcp"
      port_range       = "22"
      source_addresses = var.ssh_sources
    }
  }

  # HTTP access
  dynamic "inbound_rule" {
    for_each = var.allow_http ? [1] : []
    content {
      protocol         = "tcp"
      port_range       = "80"
      source_addresses = var.http_sources
    }
  }

  # HTTPS access
  dynamic "inbound_rule" {
    for_each = var.allow_https ? [1] : []
    content {
      protocol         = "tcp"
      port_range       = "443"
      source_addresses = var.https_sources
    }
  }

  # ICMP (ping)
  dynamic "inbound_rule" {
    for_each = var.allow_icmp ? [1] : []
    content {
      protocol         = "icmp"
      source_addresses = var.icmp_sources
    }
  }

  # Custom inbound rules
  dynamic "inbound_rule" {
    for_each = var.custom_inbound_rules
    content {
      protocol         = inbound_rule.value.protocol
      port_range       = inbound_rule.value.port_range
      source_addresses = inbound_rule.value.source_addresses
    }
  }

  # Default outbound rules - allow all
  outbound_rule {
    protocol              = "tcp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Custom outbound rules
  dynamic "outbound_rule" {
    for_each = var.custom_outbound_rules
    content {
      protocol              = outbound_rule.value.protocol
      port_range            = outbound_rule.value.port_range
      destination_addresses = outbound_rule.value.destination_addresses
    }
  }

  tags = var.tags
}
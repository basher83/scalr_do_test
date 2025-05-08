output "droplet_ip" {
  value       = digitalocean_droplet.drop_test.ipv4_address
  description = "The public IPv4 address of the droplet"
}

resource "digitalocean_floating_ip" "pchain" {
  region            = "ams3"
}

resource "digitalocean_floating_ip_assignment" "pchain" {
  ip_address = "${digitalocean_floating_ip.pchain.id}"
  droplet_id = "${digitalocean_droplet.pchain.id}"
}

output "ip_pchain_stable" {
  value = "${digitalocean_floating_ip.pchain.id}"
}

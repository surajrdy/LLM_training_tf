variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}


resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "lon1"
  size   = "s-1vcpu-1gb"
}

output "ip" {
  value = "${digitalocean_droplet.web.ipv4_address}"
}



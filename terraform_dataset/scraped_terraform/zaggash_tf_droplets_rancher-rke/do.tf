resource "digitalocean_tag" "rancherlb-https" {
  name        = "rancher-https"
}

data "template_file" "userdata_rancher" {
  template    = file("files/userdata_rancher")
  vars = {
    docker_version            = var.docker_version
  }
}

resource "digitalocean_droplet" "rancher-all" {
  count       = var.rancher_all_roles_nodes
  image       = var.nodes_image
  name        = "${var.prefix}-rancher-all-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  user_data   = data.template_file.userdata_rancher.rendered
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [digitalocean_tag.rancherlb-https.id, join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}

resource "digitalocean_droplet" "rancher-etcd" {
  count       = var.rancher_etcd_nodes
  image       = var.nodes_image
  name        = "${var.prefix}-rancher-etcd-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  user_data   = data.template_file.userdata_rancher.rendered
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }

    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}

resource "digitalocean_droplet" "rancher-cp" {
  count       = var.rancher_cp_nodes
  image       = var.nodes_image
  name        = "${var.prefix}-rancher-cp-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  user_data   = data.template_file.userdata_rancher.rendered
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }
    
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}

resource "digitalocean_droplet" "rancher-worker" {
  count       = var.rancher_worker_nodes
  image       = var.nodes_image
  name        = "${var.prefix}-rancher-worker-${count.index}"
  vpc_uuid    = digitalocean_vpc.infra-clusters.id
  region      = var.region_server
  size        = var.size
  user_data   = data.template_file.userdata_rancher.rendered
  ssh_keys    = [local.ssh_public_fingerprint]
  tags        = [digitalocean_tag.rancherlb-https.id, join("",["user:",replace(split("@",data.digitalocean_account.do-account.email)[0],".","-")])]

  provisioner "remote-exec" {
    connection {
      type          = "ssh"
      user          = var.user
      host          = self.ipv4_address
      private_key   = local.ssh_private_key
    }
    
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
  }
}

resource "digitalocean_loadbalancer" "rancher-lb" {
  name        = "${var.prefix}-rancherlb"
  region      = var.region_server
  vpc_uuid    = digitalocean_vpc.infra-clusters.id

  forwarding_rule {
    entry_port        = 80
    entry_protocol    = "http"
    target_port       = 80
    target_protocol   = "http"
  }
  forwarding_rule {
    entry_port        = 443
    entry_protocol    = "https"
    target_port       = 443
    target_protocol   = "https"
    tls_passthrough   = true
  }

  healthcheck {
    port              = 443
    protocol          = "tcp"
  }
  
  droplet_tag             = digitalocean_tag.rancherlb-https.id

}

locals {
  rancherlb-dns  = "${var.prefix}-rancherlb.${digitalocean_loadbalancer.rancher-lb.ip}.sslip.io"
}

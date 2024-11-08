// Consul
resource "aws_instance" "consul" {
  ami = "ami-bb6b26c8" # Ubuntu 16.10
  instance_type = "t2.micro"
  key_name = "gateway"
  security_groups = ["default"]
  user_data = "${data.template_file.consul-bootstrap.rendered}"

  tags = {
    Name = "elasticsearch-consul"
  }
}

data "template_file" "consul-bootstrap" {
  template = "${file("bootstrap/consul_bootstrap.tpl")}"
}

// NGINX
data "template_file" "nginx-config" {
  template = "${file("nginx.tpl")}"
}

data "template_file" "nginx-bootstrap" {
    template            = "${file("bootstrap/nginx_bootstrap.tpl")}"

  vars = {
    nginx-config = "${data.template_file.nginx-config.rendered}"
    consul_ip = "${aws_instance.consul.private_ip}"
  }
}

resource "aws_instance" "nginx" {
  ami                   = "ami-bb6b26c8" # Ubuntu 16.10
  instance_type         = "t2.micro"
  key_name              = "gateway"
  user_data             = "${data.template_file.nginx-bootstrap.rendered}"
  security_groups       = ["default"]

  tags = {
    Name = "elasticsearch-proxy"
  }
}

resource "aws_route53_record" "elasticsearch-proxy" {
  zone_id = "Z3USS9SVLB2LY1"
  name = "elasticsearch.informaticslab.co.uk."
  type = "A"
  ttl = "60"
  records = ["${aws_instance.nginx.private_ip}"]
}

// Elasticsearch
resource aws_elasticsearch_domain "elasticsearch" {
  domain_name = "jade"
  elasticsearch_version = "2.3"

  cluster_config {
    instance_type = "t2.micro.elasticsearch"
  }

  ebs_options {
    ebs_enabled = "true"
    volume_size = "10"
  }

  access_policies = <<CONFIG
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Condition": {
                "IpAddress": {"aws:SourceIp": ["${aws_instance.nginx.public_ip}/32"]}
            }
        }
    ]
    }
  CONFIG
}

provider "consul" {
  address = "${aws_instance.consul.private_ip}:8500"
}

// data "consul_keys" "elasticsearch" {
//   key {
//     name = "elasticsearch-dns"
//     path = "elasticsearch/dns"
//     default = "${aws_elasticsearch_domain.elasticsearch.domain_name}"
//   }
// }

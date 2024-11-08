resource "aws_elb" "app-load_balancer" {
  name = "public-app-load-balancer"

  subnets = ["${aws_subnet.vpc.id}"]

  security_groups = ["${aws_security_group.app-allow_all.id}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    target = "TCP:80"
    interval = 30
  }

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

}

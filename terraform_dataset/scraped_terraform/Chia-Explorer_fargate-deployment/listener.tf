resource "aws_lb_target_group" "this" {
  name        = "${var.service_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    enabled           = true
    path              = var.health_check_path
    interval          = var.health_check_interval
    healthy_threshold = var.health_check_healthy_threshold
  }
}

resource "aws_lb_listener" "this_http" {
  count = var.https ? 0 : 1

  load_balancer_arn = var.alb_arn

  # Let cloudflare handle all HTTPS
  port     = "80"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "this_https" {
  count = var.https ? 1 : 0

  load_balancer_arn = var.alb_arn

  # Full encryption between cloudflare and AWS
  port     = "443"
  protocol = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  # not ideal for this to be hardcoded but saving time for now
  # beware, this exists in chiaexplorer-terraform so could be accidently deleted from there...
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

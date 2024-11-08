resource "aws_lb_target_group" "ecs-faragte-target-group" {
  name        = "ecs-faragte-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.ecs-fargate-deployment.id
  health_check {
    path = var.health_check_path
  }
}
resource "aws_ecs_cluster" "telecom_ecs" {
  name = "telecom-ecs"
}

resource "aws_ecs_task_definition" "telecom_task" {
  family                   = "telecom-task"
  container_definitions     = <<DEFINITION
[
  {
    "name": "telecom-service",
    "image": "nginx:latest",
    "cpu": 128,
    "memory": 256,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "telecom_ecs_service" {
  name           = "telecom_ecs_service"
  cluster        = aws_ecs_cluster.telecom_ecs.id
  task_definition = aws_ecs_task_definition.telecom_task.arn
  desired_count  = 2
  launch_type    = "EC2"
}

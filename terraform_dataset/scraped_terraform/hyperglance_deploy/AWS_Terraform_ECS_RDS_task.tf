# Hyperglance task definition
resource "aws_ecs_task_definition" "hyperglance" {
  family                   = "hyperglance-${random_string.string.id}"
  execution_role_arn       = aws_iam_role.hg_task_execution_role.arn # Assign ECS task execution role
  task_role_arn            = aws_iam_role.hg_wildfly_task_role.arn   # Assign task to enable container to poll AWS APIs
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.hyperglance_ecs_task_cpu
  memory                   = var.hyperglance_ecs_task_memory

  # Populate EFS mount with required files from container image to overcome file specific bind mount limitation
  container_definitions = jsonencode([
    {
      name      = "initContainer"
      image     = "hyperglance/wildfly"
      essential = false
      "mountPoints" : [{
        "sourceVolume" : "wildfly"
        "containerPath" : "/mnt/wildfly"
        },
        { "sourceVolume" : "hyperglance"
      "containerPath" : "/mnt/hyperglance" }]
      "command" : [
        "/bin/sh -c \"echo h6ZRHkSWoPZFAZCnm0Lx2EPOzQ3qeyR2oAziMLxQKKyUKky+lKJfYhbdE4T0dIhgcnSrUy/65dhOAXlDFdyegIVe1EVURapOJNVhPNA04R5ZNKDheFFK7YjR2UIz3LiWt4vGTf89uCKxDonM1QSxL88dg/e+oVicBlS4Zm6x636B/1igeHmo60sTZ7NwMLwavoXwdlgSxM4QJA1FeSu3SBCnrr2uTThNP9Nqfu0YbwKxMGAy+HwdPb7MXzfq6HOEyPbe0sp6zBzng/1x1R0+f14OklQQQOZ/Hi3W+W+nGs8a0sJHgFGZ9RxH6MVP5nnYYBGCgnFuNHBnjeSJtRwU8XZBKHszyu6bmo+Yq57u90x4yAQwaSYqOxc0FNYFNKF+316xvOZGOwHsEDWQqDfIRec08UeciJZngje5Le3xsDULXpNWlrJkox6xIrXXoq7zSC0qS/fzon2ghwlVu/zBjCSIvt8lqatdoyH4d9eNBYcFIjka4QOp1BzMP39H5NuEXe78tI1ZJ5iMRKAMeoeOxmvvhYRBpQ7tlbmyYZgcr5j3h2yeVHC/luiFdFVgHFMaeKxIEKS1+m2e3S5MfKUOsv/8TayvmYHFlA4HX6rdjd9UfjvBVSgy9mNmxDjdt62JV04/x4Oy4QRfFtGYjvGXFIIKi3M48eTK7lqtUo0r0ioGb1EDSQtVAb3r3Pjb9LL9NNau5zBZBkCiZ3uf/+M3mJchWjp/Qaga3j9hRytJYRARmVSkLFblM3OiIodpmTcplqjuBW7O9F/Jd0AhX02iKyY9vrfmW5dN3dA4fd7rYecjS0mRIHl4h3BwDbRD3Lzt7tLj5zb3suHBvhkMjnP1wA== > /opt/wildfly/standalone/data/hg.bin && cp -R -n /opt/wildfly/standalone/data/* /mnt/wildfly && cp -R -n /var/lib/hyperglance/* /mnt/hyperglance\""
      ],
      "entryPoint" : [
        "sh",
        "-c"
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.hyperglance.name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "initContainer"
        }
      }
    },
    {
      name      = "hyperglance"
      image     = "hyperglance/wildfly"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        },
        {
          containerPort = 8443
          hostPort      = 8443
        }
      ]
      "ulimits" : [
        {
          "name" : "nofile",
          "softLimit" : 65535,
          "hardLimit" : 65535
        }
      ]
      "mountPoints" : [
        {
          "sourceVolume" : "wildfly"
          "containerPath" : "/opt/wildfly/standalone/data"
        },
        { "sourceVolume" : "hyperglance"
        "containerPath" : "/var/lib/hyperglance" }
      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.hyperglance.name,
          "awslogs-region" : var.region,
          "awslogs-stream-prefix" : "hyperglance"
        }
      }
      "secrets" : [
        {
          "name" : "POSTGRESQL_PASSWORD",
          "valueFrom" : "${aws_secretsmanager_secret.rds-postgresql-password.arn}"
      }]
      "environment" : [
        { "name" : "RUNNING_IN", "value" : "AWS" },
        { "name" : "MAX_HEAPSIZE", "value" : "${local.MAX_HEAPSIZE}" },
        { "name" : "SAML_ENABLED", "value" : "false" },
        { "name" : "POSTGRESQL_HOST", "value" : "${local.postgresql_hostname}" },
        { "name" : "POSTGRESQL_USERNAME", "value" : "${aws_rds_cluster.postgresql.master_username}" },
        { "name" : "_URL", "value" : "${aws_lb.hyperglance.dns_name}" }
      ],
      "dependsOn" : [
        {
          "containerName" : "initContainer",
          "condition" : "COMPLETE"
        }
      ]
    }
  ])

  volume {
    name = "wildfly"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.hyperglance.id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.wildfly.id
        iam             = "ENABLED"
      }
    }
  }
  volume {
    name = "hyperglance"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.hyperglance.id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = aws_efs_access_point.hyperglance.id
        iam             = "ENABLED"
      }
    }
  }
}
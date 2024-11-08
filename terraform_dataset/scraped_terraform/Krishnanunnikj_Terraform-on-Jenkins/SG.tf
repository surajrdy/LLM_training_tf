#Creating security group
resource "aws_security_group" "allow_tls" {
  name        = "tf_sg_group"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = "{$var.port}"
    iterator = port
    content {
      description = "From terraform"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

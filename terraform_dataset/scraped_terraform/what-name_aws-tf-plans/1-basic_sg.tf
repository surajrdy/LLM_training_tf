## Allow ingress SSH traffic from anywhere
resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  description = "Allow ssh from anywhere"
  vpc_id = "${aws_vpc.example_vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "example"
  }
}

## Allow ingress HTTP traffic from anywhere
resource "aws_security_group" "allow_http" {
  name = "allow_http"
  description = "Allow ingress HTTP traffic"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.example_vpc.id}"
  tags = {
    Project = "example"
  }
}

## Allow all egress traffic
resource "aws_security_group" "allow_egress" {
  name = "allow_egress"
  description = "Allow all egress Traffic"
  vpc_id = "${aws_vpc.example_vpc.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "example"
  }
}
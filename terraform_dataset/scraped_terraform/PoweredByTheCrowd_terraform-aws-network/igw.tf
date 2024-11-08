# the internet gateway used by the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}",
  depends_on = ["aws_vpc.vpc"]

  tags {
    Name = "igw-${var.environment}",
    Env = "${var.environment}",
    Terraform = "true"
  }
}
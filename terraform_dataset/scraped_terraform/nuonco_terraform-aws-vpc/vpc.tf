data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = var.name
  cidr = var.cidr

  azs              = data.aws_availability_zones.available.zone_ids
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  create_database_subnet_group = true

  public_subnet_tags = {
    "visibility"             = "public",
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "visibility"                      = "private",
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "vpc_untagged" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.5"

  name = "${var.name}-untagged"
  cidr = var.cidr

  azs              = data.aws_availability_zones.available.zone_ids
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  create_database_subnet_group = true
}

resource "aws_internet_gateway" "my_internet_gateway" {
    vpc_id = aws_vpc.eks_command.id
}

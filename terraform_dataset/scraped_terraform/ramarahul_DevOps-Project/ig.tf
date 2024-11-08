resource "aws_internet_gateway" "devops_project_ig" {
  vpc_id = aws_vpc.devops_project_vpc.id
  
  tags = {
    Name = "devops_project_ig"
  }
}
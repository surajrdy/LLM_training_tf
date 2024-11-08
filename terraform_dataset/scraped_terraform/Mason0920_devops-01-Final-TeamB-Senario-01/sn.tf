resource "aws_subnet" "subnet_private1" {
    vpc_id                  = aws_vpc.project4_vpc.id
    cidr_block              = "172.31.128.0/20"
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false
}


resource "aws_subnet" "subnet_private2" {
    vpc_id                  = aws_vpc.project4_vpc.id
    cidr_block              = "172.31.144.0/20"
    availability_zone       = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false

}

resource "aws_subnet" "subnet_public1" {
    vpc_id                  = aws_vpc.project4_vpc.id
    cidr_block              = "172.31.0.0/20"
    availability_zone       = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = false

}

resource "aws_subnet" "subnet_public2" {
    vpc_id                  = aws_vpc.project4_vpc.id
    cidr_block              = "172.31.16.0/20"
    availability_zone       = data.aws_availability_zones.available.names[1]
    map_public_ip_on_launch = false

}
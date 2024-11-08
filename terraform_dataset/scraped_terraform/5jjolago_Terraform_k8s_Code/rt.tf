resource "aws_route_table" "ozzorago-public-rt" {
    vpc_id = aws_vpc.ozzorago_vpc.id
    tags = {
      "Name" = "ozzorago-public-rt"
    }
    
}
resource "aws_route_table" "ozzorago-private-rt" {
    vpc_id = aws_vpc.ozzorago_vpc.id
    tags = {
      "Name" = "ozzorago-private-rt"
    }
  
}

### 라우팅 ###

resource "aws_route" "ozzorago-public-route" {
    route_table_id = aws_route_table.ozzorago-public-rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ozzogaro-ig.id
}

resource "aws_route" "ozzorago-private-route" {
    route_table_id = aws_route_table.ozzorago-private-rt.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ozzorago-nat.id

}

### Route table associate ####

resource "aws_route_table_association" "ozzorago-public-rt-as-01" {
    subnet_id = aws_subnet.public-sn-1.id
    route_table_id = aws_route_table.ozzorago-public-rt.id
}
resource "aws_route_table_association" "ozzorago-public-rt-as-02" {
    subnet_id = aws_subnet.public-sn-2.id
    route_table_id = aws_route_table.ozzorago-public-rt.id
}
resource "aws_route_table_association" "ozzorago-public-rt-as-03" {
    subnet_id = aws_subnet.public-sn-3.id
    route_table_id = aws_route_table.ozzorago-public-rt.id
}

resource "aws_route_table_association" "ozzorago-private-rt-as-01" {
    subnet_id = aws_subnet.private-sn-1.id
    route_table_id = aws_route_table.ozzorago-private-rt.id
}
resource "aws_route_table_association" "ozzorago-private-rt-as-02" {
    subnet_id = aws_subnet.private-sn-2.id
    route_table_id = aws_route_table.ozzorago-private-rt.id
}
resource "aws_route_table_association" "ozzorago-private-rt-as-03" {
    subnet_id = aws_subnet.private-sn-3.id
    route_table_id = aws_route_table.ozzorago-private-rt.id
}
resource "aws_route_table_association" "ozzorago-private-rt-as-04" {
    subnet_id = aws_subnet.private-sn-4.id
    route_table_id = aws_route_table.ozzorago-private-rt.id
}
resource "aws_route_table_association" "ozzorago-private-rt-as-05" {
    subnet_id = aws_subnet.private-sn-5.id
    route_table_id = aws_route_table.ozzorago-private-rt.id
}
resource "aws_route_table_association" "ozzorago-private-rt-as-06" {
    subnet_id = aws_subnet.private-sn-6.id
    route_table_id = aws_route_table.ozzorago-private-rt.id
}
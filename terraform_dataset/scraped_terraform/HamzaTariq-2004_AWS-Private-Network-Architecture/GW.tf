resource "aws_vpc_endpoint" "s3-endpoint" {
    vpc_id = aws_vpc.VPC-A.id
    service_name = "com.amazonaws.us-east-1.s3"

    #Attach the endpoint to the route table of private subnet
    route_table_ids = [aws_route_table.private-rt-A.id]

    tags = {
      Name = "S3GatewayEndpoint"
    }
}
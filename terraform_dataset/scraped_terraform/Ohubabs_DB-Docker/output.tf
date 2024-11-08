/*output "Docker_EIP" {
    description = "Docker EIP"
    value = aws_eip.Docker_EIP.public_ip
}*/

output "Docker_IP" {
    description = "Docker Instance Public IP"
    value = aws_instance.Docker.public_ip
}

output "DBZ_DNS" {
    description = "Docker Instance Public DNS"
    value = aws_instance.Docker.public_dns
}

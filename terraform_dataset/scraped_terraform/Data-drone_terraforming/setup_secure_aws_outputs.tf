resource "local_file" "AnsibleInventory" {
 content = templatefile("inventory.tmpl",
    {
    bastion-id = aws_instance.bastion.id,
    bastion-ip = aws_instance.bastion.public_ip,
    bastion-dns = aws_instance.bastion.private_dns
    }
 )
 filename = "inventory"
}
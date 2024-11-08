resource "aws_key_pair" "deployer" {
  key_name   = "${local.app_name}-deployer-key"
  public_key = file("${path.module}/ssh_key.pub")
}
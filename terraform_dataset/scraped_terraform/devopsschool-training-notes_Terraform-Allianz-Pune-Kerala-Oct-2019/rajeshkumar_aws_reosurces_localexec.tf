resource "aws_instance" "web" {
  ami           = "ami-5b673c34"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }

 provisioner "local-exec" {
    command = "echo 'Welcome to Terraform Allianz Classx' >> /Users/rajeshkumar/terraform/local-exec.txt"
  }

 provisioner "local-exec" {
    command = "/bin/bash deploy.sh"
  }

 provisioner "local-exec" {
    command = "open WFH, '>completed.txt' and print WFH scalar localtime"
    interpreter = ["perl", "-e"]
  }
}

provider "aws" {
     region = var.region
     access_key = var.access_key
     secret_key = var.secret_key
}

resource "aws_instance" "my" {
      ami = "ami-06ec8443c2a35b0ba"
        instance_type = "t2.micro"
	key_name      = "${aws_key_pair.deployer.key_name}"
        vpc_security_group_ids = [aws_security_group.my.id]
#	user_data = file("user_data.sh")
    tags = {
        Name = "Jenkins Main Server Build by terraform"
        Owner = "Valentine Kravtsov"
    }
        user_data = <<EOF
#!/bin/bash
#sudo apt update
#sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#sudo apt update
#apt-cache policy docker-ce
#sudo apt install -y docker-ce
#sudo docker pull orchardup/jenkins
#sudo docker run -d -p 80:8080 orchardup/jenkins
#wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
#sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
#sudo apt update
#sudo apt install -y openjdk-8-jre-headless
#sudo apt install -y jenkins
#sudo systemctl start jenkins
#sudo apt update
#sudo apt install -y apache2
#sudo systemctl stop apache2
#sudo yum install -y java-1.8.0-openjdk-devel
#curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
#sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
#sudo yum install -y jenkins
#sudo systemctl start jenkins
#sudo dnf update -y
sudo dnf install -y java-1.8.0-openjdk-devel
#sudo dnf update -y
sudo yum install -y wget
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
#sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum update -y
sudo yum install jenkins -y
sudo systemctl start jenkins
#sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
#sudo firewall-cmd --reload
sudo dnf install -y httpd
#sudo systemctl start httpd
sudo chmod 777 /var/www/html -R
sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /var/www/html/index.html
#sudo systemctl start apache2
sudo systemctl start httpd
sudo dnf install git -y
sudo dnf install python3 -y
EOF

    lifecycle {
        prevent_destroy = false
    }
}
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDW/RYldFRnPq3/nqNXg5iq5AZ1bvrun6DAFfdespghx8f1hU7HHpNUPt1PRzg9p7MsostPEk+SxzrwcSy5H+4PBYIUK5PZ45omlI9JQ6rWc4CYjmqkiGssBuq0LCN9Stjm27zKO71C5AziQlyU4vECTaxejb8zUxg+eLq7LXDhtA4Hj3m0nv2Y2nvsthr+AMVYlK9LAV5IyhvPaQRsf4fc9KyEp0KQp2Qy1f77fpvv18VPMCi1KcZVrR515HtHXoEJ8TygIxVmrEgQUAXqrtrcOv42wmsZwGgH16OJNuZOpmjErxZgWtVaY1aXNbpYrzwEfXSjKsIkc7t8G66CEob kravtsov@admings-MacBook-Pro.local"
}
resource "aws_instance" "my-slave" {
      ami = "ami-05f7491af5eef733a"
        instance_type = "t2.micro"
        key_name      = "${aws_key_pair.deployer.key_name}"
        vpc_security_group_ids = [aws_security_group.my.id]
#       user_data = file("user_data.sh")
	user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install -y docker-ce
#sudo docker pull orchardup/jenkins
#sudo docker run -d -p 80:8080 orchardup/jenkins
#wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
#sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y openjdk-8-jre-headless
#sudo apt install -y jenkins
#sudo systemctl start jenkins
#sudo apt update
#sudo apt install -y apache2
#sudo systemctl stop apache2
#sudo chmod 777 /var/www/html -R
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /var/www/html/index.html
#sudo systemctl start apache2
EOF

    tags = {
        Name = "Jenkins Slave Server Build by terraform"
        Owner = "Valentine Kravtsov"
   }
}

resource "aws_instance" "my-slave-sec" {
      ami = "ami-05f7491af5eef733a"
        instance_type = "t2.micro"
        key_name      = "${aws_key_pair.deployer.key_name}"
        vpc_security_group_ids = [aws_security_group.my.id]
#       user_data = file("user_data.sh")
        user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install -y docker-ce
#sudo docker pull orchardup/jenkins
#sudo docker run -d -p 80:8080 orchardup/jenkins
#wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
#sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install -y openjdk-8-jre-headless
#sudo apt install -y jenkins
#sudo systemctl start jenkins
#sudo apt update
#sudo apt install -y apache2
#sudo systemctl stop apache2
#sudo chmod 777 /var/www/html -R
#sudo cat /var/lib/jenkins/secrets/initialAdminPassword > /var/www/html/index.html
#sudo systemctl start apache2
EOF

    tags = {
        Name = "Jenkins Slave sec Server Build by terraform"
        Owner = "Valentine Kravtsov"
   }
}

#resource "aws_key_pair" "deployer" {
#  key_name   = ""
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDRawyBi27JHjR6/g4dcNWXzmxbQKrvyF4bLzxg6WtdLIXPqzN6xYjj/zSeRhH5/RxXQ8wxB6c2bQfK6bTM+QmOdZeM8E6S3OBMUfqRTTqIFXgBj1V1s83R072tJdl2mChx2TmcELpHiD/2C6XY0m5etnXNf8RupBbRF6oEdXvPpsy9KDPWYjzIGMT6o3JmawNfs/vta+0dD4pWG28a+I/VJPCXGFKVd/kxEWgQnS9jy5J5KGMRhiWQDs9sptl7GUDP+upiqA8IelfyE20fP0PMtdqkdGGUybfuuLeWyJdK+L0tNFVA8jG1KdOpSDl9abA1A3Y4y0OFhH9+sTW2UoVntm005z6XWUpqpvHBBAQakUCPHQ2PTtVGJkDQLZtKvKSc7J24/xAj+F1AAda6LFL3NfuAOhrOZ5UvqvbLvDXL0gcQXwMfjyKmcnvLUtK4gEhHQPHwaKUl5ZWvxt/TQaB/ZO03EfzNM//sQL48oueg8X4dlaaZyg160cMHoZcWp2s= ubuntu@ip-172-31-40-43"
#	}

output "instance_ips" {
  value = aws_instance.my.*.public_ip
}
resource "aws_security_group" "my" {
    name = "my_web_server"
    description = "My_First_sec_group"
  

    ingress {
        from_port = 80
        protocol = "tcp"
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        protocol = "tcp"
        to_port = 8080
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        protocol = "tcp"
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]    
    }
    egress {
        from_port = 0
        protocol = "-1"
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}

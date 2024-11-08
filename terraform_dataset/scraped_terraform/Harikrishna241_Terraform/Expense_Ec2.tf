resource "aws_instance" "Expense" {
    count = length(var.instance_names)
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = merge(
        var.tag_names,
        {
            Name = var.instance_names[count.index]
            module = var.instance_names[count.index]
        }
    )
}

resource "aws_security_group" "sg" { 
    name = var.sg_name
    tags={
        name=var.sg_name
        createdby=var.createdby
    }
    ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
    }
    egress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "-1"
    cidr_blocks = var.cidr_blocks
    }
}
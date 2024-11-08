resource "aws_launch_configuration" "bastions-kubernetesmcalik-com" {
  name_prefix                 = "bastions.kubernetesmcalik.com-"
  image_id                    = "ami-0d8618ba6320df983"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.kubernetes-kubernetesmcalik-com-4f94efba1a3c41fb128f0045d0d4cf97.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.bastions-kubernetesmcalik-com.id}"
  security_groups             = ["${aws_security_group.bastion-kubernetesmcalik-com.id}"]
  associate_public_ip_address = true

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 32
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "master-us-west-2a-masters-kubernetesmcalik-com" {
  name_prefix                 = "master-us-west-2a.masters.kubernetesmcalik.com-"
  image_id                    = "ami-0d8618ba6320df983"
  instance_type               = "${var.master_instance_type}"
  key_name                    = "${aws_key_pair.kubernetes-kubernetesmcalik-com-4f94efba1a3c41fb128f0045d0d4cf97.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-kubernetesmcalik-com.id}"
  security_groups             = ["${aws_security_group.masters-kubernetesmcalik-com.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2a.masters.kubernetesmcalik.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "master-us-west-2b-masters-kubernetesmcalik-com" {
  name_prefix                 = "master-us-west-2b.masters.kubernetesmcalik.com-"
  image_id                    = "ami-0d8618ba6320df983"
  instance_type               = "${var.master_instance_type}"
  key_name                    = "${aws_key_pair.kubernetes-kubernetesmcalik-com-4f94efba1a3c41fb128f0045d0d4cf97.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-kubernetesmcalik-com.id}"
  security_groups             = ["${aws_security_group.masters-kubernetesmcalik-com.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2b.masters.kubernetesmcalik.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "master-us-west-2c-masters-kubernetesmcalik-com" {
  name_prefix                 = "master-us-west-2c.masters.kubernetesmcalik.com-"
  image_id                    = "ami-0d8618ba6320df983"
  instance_type               = "${var.master_instance_type}"
  key_name                    = "${aws_key_pair.kubernetes-kubernetesmcalik-com-4f94efba1a3c41fb128f0045d0d4cf97.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.masters-kubernetesmcalik-com.id}"
  security_groups             = ["${aws_security_group.masters-kubernetesmcalik-com.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_master-us-west-2c.masters.kubernetesmcalik.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 64
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}

resource "aws_launch_configuration" "nodes-kubernetesmcalik-com" {
  name_prefix                 = "nodes.kubernetesmcalik.com-"
  image_id                    = "ami-0d8618ba6320df983"
  instance_type               = "${var.node_instance_type}"
  key_name                    = "${aws_key_pair.kubernetes-kubernetesmcalik-com-4f94efba1a3c41fb128f0045d0d4cf97.id}"
  iam_instance_profile        = "${aws_iam_instance_profile.nodes-kubernetesmcalik-com.id}"
  security_groups             = ["${aws_security_group.nodes-kubernetesmcalik-com.id}"]
  associate_public_ip_address = false
  user_data                   = "${file("${path.module}/data/aws_launch_configuration_nodes.kubernetesmcalik.com_user_data")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 128
    delete_on_termination = true
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = false
}
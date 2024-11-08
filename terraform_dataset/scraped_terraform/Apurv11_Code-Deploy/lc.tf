data "template_file" "user_data" {
  template             = "${file("${module.shared.path}/ec2/user_data/init_script.sh")}"
}

resource "aws_launch_configuration" "CodeDeploy_LC" {
  name                 = "CodeDeploy_LC"
  image_id             = "${var.source_ami}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.codedeploy.name }"
  key_name             = "${var.key_name}"
  security_groups      = ["${aws_security_group.kubernetes_node_asg_sg.id}"]
  user_data            = "${data.template_file.user_data.rendered}"

  root_block_device {
    volume_size        = "${var.root_volume_size}"
    volume_type        = "${var.root_volume_type}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

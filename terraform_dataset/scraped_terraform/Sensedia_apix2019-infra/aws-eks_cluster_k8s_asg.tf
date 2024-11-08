resource "aws_autoscaling_group" "kubernetes" {
  desired_capacity     = 1
  launch_configuration = "${aws_launch_configuration.kubernetes.id}"
  max_size             = 4
  min_size             = 1
  name                 = "${var.cluster_name}"
  vpc_zone_identifier  = ["${aws_subnet.demo.*.id}"] 

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  load_balancers = ["${aws_elb.elb_gtw.name}"]
}

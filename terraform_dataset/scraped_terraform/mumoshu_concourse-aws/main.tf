# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

#module "postgres" {
#    source = "./postgres"
#    access_allowed_security_groups = "${aws_security_group.atc.id}"
#}

module "autoscaling_hooks" {
    source = "./autoscaling/hooks/enabled"
    target_asg_name = "${aws_autoscaling_group.worker-asg.name}"
    prefix = "${var.prefix}"
}

module "autoscaling_schedule" {
    source = "./autoscaling/schedule/enabled"
    target_asg_name = "${aws_autoscaling_group.worker-asg.name}"
    num_workers_during_working_time = 2
    max_num_workers_during_working_time = "${var.asg_max}"
    num_workers_during_non_working_time = 0
}

module "autoscaling_utilization" {
    source = "./autoscaling/utilization/enabled"
    target_asg_name = "${aws_autoscaling_group.worker-asg.name}"
}

resource "aws_elb" "web-elb" {
  name = "${var.prefix}concourse-lb"

  # The same availability zone as our instances
  # Only one of SubnetIds or AvailabilityZones may be specified
  #availability_zones = ["${split(",", var.availability_zones)}"]
  security_groups = ["${aws_security_group.external_lb.id}"]
  subnets = ["${split(",", var.subnet_id)}"]
  cross_zone_load_balancing = "true"

  listener {
    instance_port = "${var.elb_listener_instance_port}"
    instance_protocol = "http"
    lb_port = "${var.elb_listener_lb_port}"
    lb_protocol = "${var.elb_listener_lb_protocol}"
    ssl_certificate_id = "${var.ssl_certificate_arn}"
  }

  listener {
    instance_port = "${var.tsa_port}"
    instance_protocol = "tcp"
    lb_port = "${var.tsa_port}"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "TCP:${var.elb_listener_instance_port}"
    interval = 30
  }
}

resource "aws_autoscaling_group" "web-asg" {
  # See "Phasing in" an Autoscaling Group? https://groups.google.com/forum/#!msg/terraform-tool/7Gdhv1OAc80/iNQ93riiLwAJ
  # * Recreation of the launch configuration triggers recreation of this ASG and its EC2 instances
  # * Modification to the lc (change to referring AMI) triggers recreation of this ASG
  name = "${var.prefix}${aws_launch_configuration.web-lc.name}${var.ami}"
  availability_zones = ["${split(",", var.availability_zones)}"]
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  desired_capacity = "${var.web_asg_desired}"
  launch_configuration = "${aws_launch_configuration.web-lc.name}"
  load_balancers = ["${aws_elb.web-elb.name}"]
  vpc_zone_identifier = ["${split(",", var.subnet_id)}"]
  tag {
    key = "Name"
    value = "${var.prefix}web"
    propagate_at_launch = "true"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "worker-asg" {
  name = "${var.prefix}${aws_launch_configuration.worker-lc.name}${var.ami}"
  availability_zones = ["${split(",", var.availability_zones)}"]
  max_size = "${var.asg_max}"
  min_size = "${var.asg_min}"
  desired_capacity = "${var.worker_asg_desired}"
  launch_configuration = "${aws_launch_configuration.worker-lc.name}"
  vpc_zone_identifier = ["${split(",", var.subnet_id)}"]
  tag {
    key = "Name"
    value = "${var.prefix}worker"
    propagate_at_launch = "true"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "web-lc" {
  # Omit launch configuration name to avoid collisions on create_before_destroy
  # ref. https://github.com/hashicorp/terraform/issues/1109#issuecomment-97970885
  #image_id = "${lookup(var.aws_amis, var.aws_region)}"
  image_id = "${var.ami}"
  instance_type = "${var.web_instance_type}"
  security_groups = ["${aws_security_group.default.id}","${aws_security_group.atc.id}","${aws_security_group.tsa.id}"]
  user_data = "${template_cloudinit_config.web.rendered}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "worker-lc" {
  #image_id = "${lookup(var.aws_amis, var.aws_region)}"
  image_id = "${var.ami}"
  instance_type = "${var.worker_instance_type}"
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.worker.id}"]
  user_data = "${template_cloudinit_config.worker.rendered}"
  key_name = "${var.key_name}"
  associate_public_ip_address = true
  iam_instance_profile = "${var.worker_instance_profile}"
  root_block_device {
    # For fast booting, we use gp2
    volume_type = "gp2"
    # You need enough capacity to avoid the following error while docker export & untar'ing:
    #
    # *snip*
    # tar: etc/alternatives: Cannot stat: Input/output error
    # tar: etc: Cannot stat: Input/output error
    # tar: dev: Cannot stat: Input/output error
    # tar: bin: Cannot stat: Input/output error
    # tar: Exiting with failure status due to previous errors
    #
    # resource script '/opt/resource/in [/tmp/build/get]' failed: exit status 2
    #
    # Or the following error when tried to run the job:
    # resource_pool: creating container directory: mkdir /var/lib/concourse/linux/depot/hntrh2no0mh: no space left on device
    volume_size = "50"
    delete_on_termination = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "template_file" "install_concourse" {
  template = "${file("${path.module}/00_install_concourse.sh.tpl")}"
}

resource "template_file" "start_concourse_web" {
  template = "${file("${path.module}/01_start_concourse_web.sh.tpl")}"

  vars {
    session_signing_key = "${file("${var.session_signing_key}")}"
    tsa_host_key = "${file("${var.tsa_host_key}")}"
    tsa_authorized_keys = "${file("${var.tsa_authorized_keys}")}"
    postgres_data_source = "postgres://${var.db_username}:${var.db_password}@${aws_db_instance.default.endpoint}/concourse"
    external_url = "${var.elb_listener_lb_protocol}://${element(split(",","${aws_elb.web-elb.dns_name},${var.custom_external_domain_name}"), var.use_custom_external_domain_name)}${element(split(",",",:${var.elb_listener_lb_port}"), var.use_custom_elb_port)}"
    basic_auth_username = "${var.basic_auth_username}"
    basic_auth_password = "${var.basic_auth_password}"
    github_auth_client_id = "${var.github_auth_client_id}"
    github_auth_client_secret = "${var.github_auth_client_secret}"
    github_auth_organizations = "${var.github_auth_organizations}"
    github_auth_teams = "${var.github_auth_teams}"
    github_auth_users = "${var.github_auth_users}"
  }
}

resource "template_file" "start_concourse_worker" {
  template = "${file("${path.module}/02_start_concourse_worker.sh.tpl")}"

  vars {
    tsa_host = "${aws_elb.web-elb.dns_name}"
    tsa_public_key = "${file("${var.tsa_public_key}")}"
    tsa_worker_private_key = "${file("${var.tsa_worker_private_key}")}"
  }
}

resource "template_cloudinit_config" "web" {
  # Make both turned off until https://github.com/hashicorp/terraform/issues/4794 is fixed
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${template_file.install_concourse.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${template_file.start_concourse_web.rendered}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "template_cloudinit_config" "worker" {
  # Make both turned off until https://github.com/hashicorp/terraform/issues/4794 is fixed
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = "${template_file.install_concourse.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${template_file.start_concourse_worker.rendered}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "default" {
  name_prefix = "${var.prefix}default"
  description = "concourse ${var.prefix}default"
  vpc_id = "${var.vpc_id}"

  # SSH access from a specific CIDRS
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "${split(",", var.in_access_allowed_cidrs)}" ]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "atc" {
  name_prefix = "${var.prefix}atc"
  description = "concourse ${var.prefix}atc"
  vpc_id = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_external_lb_to_atc_access" {
    type = "ingress"
    from_port = "${var.elb_listener_instance_port}"
    to_port = "${var.elb_listener_instance_port}"
    protocol = "tcp"

    security_group_id = "${aws_security_group.tsa.id}"
    source_security_group_id = "${aws_security_group.external_lb.id}"
}

resource "aws_security_group_rule" "allow_atc_to_worker_access" {
    type = "ingress"
    from_port = "0"
    to_port = "65535"
    protocol = "tcp"

    security_group_id = "${aws_security_group.worker.id}"
    source_security_group_id = "${aws_security_group.atc.id}"
}

resource "aws_security_group" "tsa" {
  name_prefix = "${var.prefix}tsa"
  description = "concourse ${var.prefix}tsa"
  vpc_id = "${var.vpc_id}"

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_worker_to_tsa_access" {
    type = "ingress"
    from_port = 2222
    to_port = 2222
    protocol = "tcp"

    security_group_id = "${aws_security_group.tsa.id}"
    source_security_group_id = "${aws_security_group.worker.id}"
}

resource "aws_security_group_rule" "allow_external_lb_to_tsa_access" {
    type = "ingress"
    from_port = 2222
    to_port = 2222
    protocol = "tcp"

    security_group_id = "${aws_security_group.tsa.id}"
    source_security_group_id = "${aws_security_group.external_lb.id}"
}

resource "aws_security_group" "worker" {
  name_prefix = "${var.prefix}worker"
  description = "concourse ${var.prefix}worker"
  vpc_id = "${var.vpc_id}"

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "external_lb" {
  name_prefix = "${var.prefix}lb"
  description = "concourse ${var.prefix}lb"

  vpc_id = "${var.vpc_id}"

  # HTTP access from a specific CIDRS
  ingress {
    from_port = "${var.elb_listener_lb_port}"
    to_port = "${var.elb_listener_lb_port}"
    protocol = "tcp"
    cidr_blocks = [ "${split(",", var.in_access_allowed_cidrs)}" ]
  }

  ingress {
    from_port = "${var.tsa_port}"
    to_port = "${var.tsa_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "db" {
  name_prefix = "${var.prefix}db"
  description = "concourse ${var.prefix}db"
  vpc_id = "${var.vpc_id}"

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_db_access_from_atc" {
    type = "ingress"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"

    security_group_id = "${aws_security_group.db.id}"
    source_security_group_id = "${aws_security_group.atc.id}"
}

resource "aws_db_instance" "default" {
  depends_on = ["aws_security_group.db"]
  identifier = "${var.prefix}db"
  allocated_storage = "10"
  engine = "postgres"
  engine_version = "${var.db_engine_version}"
  instance_class = "${var.db_instance_class}"
  name = "concourse"
  username = "${var.db_username}"
  password = "${var.db_password}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.db.id}"
}

resource "aws_db_subnet_group" "db" {
  name = "${var.prefix}db"
  description = "group of subnets for concourse db"
  subnet_ids = ["${split(",", var.db_subnet_ids)}"]
}

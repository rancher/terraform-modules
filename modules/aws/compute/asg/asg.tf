resource "aws_launch_configuration" "config" {
  name_prefix = "Launch-Config-${var.name}"
  image_id    = "${var.ami_id}"

  security_groups = ["${split(",", var.security_groups)}"]

  instance_type               = "${var.instance_type}"
  key_name                    = "${var.ssh_key_name}"
  associate_public_ip_address = false
  ebs_optimized               = false
  user_data                   = "${var.userdata}"
  iam_instance_profile        = "${var.iam_instance_profile}"

  root_block_device {
    volume_type = "${var.root_volume_type}"
    volume_size = "${var.root_volume_size}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "elb" {
  name  = "${var.name}-compute-asg"
  count = "${var.use_elb}"

  min_size         = "${var.scale_min_size}"
  max_size         = "${var.scale_max_size}"
  desired_capacity = "${var.scale_desired_size}"

  vpc_zone_identifier  = ["${split(",", var.subnet_ids)}"]
  launch_configuration = "${aws_launch_configuration.config.name}"

  health_check_grace_period = 900
  health_check_type         = "${var.health_check_type}"
  force_delete              = false
  load_balancers            = ["${split(",", var.lb_ids)}"]

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "spot-enabled"
    value               = "${var.spot_enabled}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "alb" {
  name  = "${var.name}-asg"
  count = "${1 - var.use_elb}"

  min_size         = "${var.scale_min_size}"
  max_size         = "${var.scale_max_size}"
  desired_capacity = "${var.scale_desired_size}"

  health_check_grace_period = 900
  health_check_type         = "${var.health_check_type}"
  force_delete              = false
  target_group_arns         = ["${split(",", var.target_group_arn)}"]

  vpc_zone_identifier  = ["${split(",", var.subnet_ids)}"]
  launch_configuration = "${aws_launch_configuration.config.name}"

  tag {
    key                 = "Name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "spot-enabled"
    value               = "${var.spot_enabled}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "name" {
  value = "${element(concat(aws_autoscaling_group.alb.*.name, aws_autoscaling_group.elb.*.name), var.use_elb)}"
}

output "id" {
  value = "${element(concat(aws_autoscaling_group.alb.*.id, aws_autoscaling_group.elb.*.id), var.use_elb)}"
}

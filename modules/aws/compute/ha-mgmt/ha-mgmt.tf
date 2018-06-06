module "asg" {
  source = "../asg"

  vpc_id             = "${var.vpc_id}"
  name               = "${var.name}"
  ami_id             = "${var.ami_id}"
  security_groups    = "${var.security_groups}"
  instance_type      = "${var.instance_type}"
  ssh_key_name       = "${var.ssh_key_name}"
  scale_min_size     = "${var.scale_min_size}"
  scale_max_size     = "${var.scale_max_size}"
  scale_desired_size = "${var.scale_desired_size}"
  userdata           = "${var.externally_defined_userdata}"
  lb_ids             = "${var.lb_ids}"

  subnet_ids          = "${var.subnet_ids}"
  health_check_type   = "${var.health_check_type}"
  health_check_target = "${var.health_check_target}"
  spot_enabled        = "${var.spot_enabled}"
  root_volume_size    = "${var.root_volume_size}"
  tags                = "${var.tags}"
}

output "asg_name" {
  value = "${module.asg.name}"
}

output "asg_id" {
  value = "${module.asg.id}"
}

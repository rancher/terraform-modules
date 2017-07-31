provider "aws" {
  region     = "${var.aws_region}"
}

data "terraform_remote_state" "database" {
  backend = "local"

  config {
    path = "${path.module}/../database/terraform.tfstate"
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    database_endpoint = "${data.terraform_remote_state.database.endpoint}"
    ip-addr           = "local-ipv4"
    database_name     = "${data.terraform_remote_state.database.database}"
    database_user     = "${data.terraform_remote_state.database.username}"
    database_password = "${data.terraform_remote_state.database.password}"
    rancher_version   = "${var.rancher_version}"
    api_ui_version    = "${var.api_ui_version}"
  }
}

module "management_elb" {
  source = "../../modules/aws/network/components/elb"

  name                    = "${var.aws_env_name}-api-mgmt"
  security_groups         = "sg-b1000dd5"
  public_subnets          = "${var.aws_public_subnet_ids}"
  instance_ssl_port       = "8080"
  proxy_proto_port_string = "80,8080"
  instance_http_port      = "80"

  health_check_target     = "TCP:8080"

  ssl_certificate_arn     = "${var.rancher_com_arn}"
}

module "management_sgs" {
  source = "../../modules/aws/network/security_groups/mgmt/ha"

  vpc_id               = "${var.vpc_id}"
  private_subnet_cidrs = "10.0.0.0/8"
}

module "compute" {
  source = "../../modules/aws/compute/ha-mgmt"

  vpc_id          = "${var.vpc_id}"
  name            = "${var.aws_env_name}-management"
  ami_id          = "${var.aws_ami_id}"
  instance_type   = "${var.aws_instance_type}"
  ssh_key_name    = "${var.aws_key_pair}"
  security_groups = "sg-d3b3dbab,sg-b2000dd6"
  lb_ids          = "${module.management_elb.elb_id}"
  spot_enabled    = "${var.spot_enabled}"

  subnet_ids                  = "${var.aws_private_subnet_ids}"
  subnet_cidrs                = "${var.aws_private_subnet_cidrs}"
  externally_defined_userdata = ""
  health_check_type           = "${var.health_check_type}"
}

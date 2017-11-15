provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

data "terraform_remote_state" "network" {
  backend = "local"

  config {
    path = "${path.module}/../network/terraform.tfstate"
  }
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
    database_endpoint = "${element(split(":", data.terraform_remote_state.database.endpoint),0)}"
    ip-addr           = "local-ipv4"
    database_name     = "${data.terraform_remote_state.database.database}"
    database_user     = "${data.terraform_remote_state.database.username}"
    database_password = "${data.terraform_remote_state.database.password}"
    rancher_version   = "${var.rancher_version}"
    sysdig_key        = "${var.sysdig_key}"
    api_ui_version    = "${var.api_ui_version}"
  }
}

module "management_elb" {
  source = "../../../modules/aws/network/components/elb"

  name                    = "${var.aws_env_name}-api-mgmt"
  security_groups         = "${module.management_sgs.elb_sg_id}"
  public_subnets          = "${data.terraform_remote_state.network.aws_public_subnet_ids}"
  instance_ssl_port       = "8080"
  proxy_proto_port_string = "80,8080"
  instance_http_port      = "80"

  health_check_target     = "HTTP:8080/v1/scripts/api.crt"

  ssl_certificate_arn     = "${data.terraform_remote_state.network.rancher_com_arn}"
}

module "management_sgs" {
  source = "../../../modules/aws/network/security_groups/mgmt/ha"

  name                 = "${var.aws_env_name}"
  vpc_id               = "${data.terraform_remote_state.network.vpc_id}"
  private_subnet_cidrs = "${data.terraform_remote_state.network.aws_public_subnet_cidrs}"
}

module "compute" {
  source = "../../../modules/aws/compute/ha-mgmt"

  vpc_id          = "${data.terraform_remote_state.network.vpc_id}"
  name            = "${var.aws_env_name}-management"
  ami_id          = "${var.aws_ami_id}"
  instance_type   = "${var.aws_instance_type}"
  ssh_key_name    = "${var.aws_key_pair}"
  security_groups = "${join(",", list(module.management_sgs.management_node_sgs))}"
  lb_ids          = "${join(",", list(module.management_elb.elb_id))}"
  spot_enabled    = "${var.spot_enabled}"

  subnet_ids                  = "${data.terraform_remote_state.network.aws_public_subnet_ids}"
  subnet_cidrs                = "${data.terraform_remote_state.network.aws_public_subnet_cidrs}"
  externally_defined_userdata = "${data.template_file.userdata.rendered}"
  health_check_type           = "${var.health_check_type}"
}

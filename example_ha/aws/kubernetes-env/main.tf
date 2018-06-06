provider "rancher" {
  api_url    = "${var.rancher_api_url}"
  access_key = "${var.rancher_access_key}"
  secret_key = "${var.rancher_secret_key}"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "rancher_environment" "ha_k8s" {
  name                = "${var.name}"
  project_template_id = "${var.project_template_id}"
}

resource "rancher_registration_token" "etcd_nodes" {
  name           = "etcd_nodes"
  environment_id = "${rancher_environment.ha_k8s.id}"

  host_labels {
    etcd = "true"
  }
}

resource "rancher_registration_token" "orchestration_nodes" {
  name           = "etcd_nodes"
  environment_id = "${rancher_environment.ha_k8s.id}"

  host_labels {
    orchestration = "true"
  }
}

resource "rancher_registration_token" "compute_nodes" {
  name           = "etcd_nodes"
  environment_id = "${rancher_environment.ha_k8s.id}"

  host_labels {
    compute = "true"
  }
}

data "template_file" "etcd_userdata" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    rancher_registration_command = "${rancher_registration_token.etcd_nodes.command}"
    ip-addr                      = "${var.cattle_agent_ip}"
  }
}

data "template_file" "orchestration_userdata" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    rancher_registration_command = "${rancher_registration_token.orchestration_nodes.command}"
    ip-addr                      = "${var.cattle_agent_ip}"
  }
}

data "template_file" "compute_userdata" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    rancher_registration_command = "${rancher_registration_token.compute_nodes.command}"
    ip-addr                      = "${var.cattle_agent_ip}"
  }
}

module "ipsec_sg" {
  source = "../../modules/aws/network/security_groups/env-ipsec"

  vpc_id            = "${var.vpc_id}"
  name              = "${var.name}-ipsec-sg"
  environment_cidrs = "${var.ipsec_node_cidrs}"
}

module "etcd_asg" {
  source = "../../modules/aws/compute/asg"

  name                = "${var.name}-etcd"
  userdata            = "${data.template_file.etcd_userdata.rendered}"
  health_check_type   = "EC2"
  ssh_key_name        = "${var.ssh_key_name}"
  security_groups     = "${module.ipsec_sg.ipsec_id}"
  lb_ids              = ""
  health_check_target = "HTTP:1620/ping"
  ami_id              = "ami-5c5a3f4a"
  subnet_ids          = "${var.subnet_ids}"
  subnet_cidrs        = "${var.subnet_cidrs}"
  vpc_id              = "${var.vpc_id}"
  instance_type       = "${var.aws_instance_type}"
}

module "orchestration_asg" {
  source = "../../modules/aws/compute/asg"

  name                = "${var.name}-orchestration"
  userdata            = "${data.template_file.orchestration_userdata.rendered}"
  health_check_type   = "EC2"
  ssh_key_name        = "${var.ssh_key_name}"
  security_groups     = "${module.ipsec_sg.ipsec_id}"
  lb_ids              = ""
  health_check_target = "HTTP:1620/ping"
  ami_id              = "ami-5c5a3f4a"
  subnet_ids          = "${var.subnet_ids}"
  subnet_cidrs        = "${var.subnet_cidrs}"
  vpc_id              = "${var.vpc_id}"
  instance_type       = "${var.aws_instance_type}"
}

module "compute_asg" {
  source = "../../modules/aws/compute/asg"

  name                = "${var.name}-compute"
  userdata            = "${data.template_file.compute_userdata.rendered}"
  health_check_type   = "EC2"
  ssh_key_name        = "${var.ssh_key_name}"
  security_groups     = "${module.ipsec_sg.ipsec_id}"
  lb_ids              = ""
  health_check_target = "HTTP:1620/ping"
  ami_id              = "ami-5c5a3f4a"
  subnet_ids          = "${var.subnet_ids}"
  subnet_cidrs        = "${var.subnet_cidrs}"
  vpc_id              = "${var.vpc_id}"
  instance_type       = "${var.aws_instance_type}"
}

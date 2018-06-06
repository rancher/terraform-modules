provider "aws" {
  region     = "${var.aws_region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

data "terraform_remote_state" "network" {
  backend = "local"

  config {
    path = "${path.module}/../network/terraform.tfstate"
  }
}

module "database" {
  source = "../../modules/aws/data/rds"

  rds_instance_name  = "${var.aws_env_name}"
  database_password  = "${var.database_password}"
  vpc_id             = "${data.terraform_remote_state.network.vpc_id}"
  source_cidr_blocks = "${concat(split(",", data.terraform_remote_state.network.aws_public_subnet_cidrs),split(",",data.terraform_remote_state.network.aws_private_subnet_cidrs))}"
  rds_instance_class = "${var.aws_rds_instance_class}"
  db_subnet_ids      = "${concat(split(",", data.terraform_remote_state.network.aws_private_subnet_ids))}"
}

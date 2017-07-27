provider "aws" {
  region     = "${var.aws_region}"
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
  vpc_id             = "${var.vpc_id}"
  source_cidr_blocks = "${concat(split(",", var.aws_public_subnet_cidrs),split(",",var.aws_private_subnet_cidrs))}"
  rds_instance_class = "${var.aws_rds_instance_class}"
  db_subnet_ids      = "${concat(split(",", var.aws_private_subnet_ids))}"
}

variable "name" {}

variable "vpc_id" {}

variable "vpc_cidr" {}

variable "public_subnet_cidrs" {}

variable "private_subnet_cidrs" {}

module "vpc_allow_all_internal" {
  source = "../vpc_all_internal"

  name     = "${var.name}"
  vpc_id   = "${var.vpc_id}"
  vpc_cidr = "${var.vpc_cidr}"
}

module "vpc_allow_all_private_subnets" {
  source = "../vpc_private_subnets"

  name                 = "${var.name}"
  vpc_id               = "${var.vpc_id}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
}

module "vpc_allow_all_public_subnets" {
  source = "../vpc_public_subnets"

  name                = "${var.name}"
  vpc_id              = "${var.vpc_id}"
  public_subnet_cidrs = "${var.public_subnet_cidrs}"
}

output "vpc_allow_all_internal_id" {
  value = "${module.vpc_allow_all_internal.vpc_all_id}"
}

output "vpc_allow_all_private_subnets_id" {
  value = "${module.vpc_allow_all_private_subnets.id}"
}

output "vpc_allow_all_public_subnets_id" {
  value = "${module.vpc_allow_all_public_subnets.id}"
}

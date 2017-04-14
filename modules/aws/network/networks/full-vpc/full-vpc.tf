//VPC For the Rancher env in this region.
module "vpc" {
  source = "../../components/vpc"
  name   = "${var.vpc_name}-vpc"
  cidr   = "${var.vpc_cidr}"
}

module "internet_gateway" {
  source = "../../components/igw"

  name   = "${var.public_subnet_name}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "public_subnets" {
  source = "../../components/public_subnet"

  name   = "${var.public_subnet_name}"
  vpc_id = "${module.vpc.vpc_id}"
  cidrs  = "${var.public_subnet_cidrs}"
  azs    = "${var.azs}"
  igw_id = "${module.internet_gateway.igw_id}"
}

module "nat" {
  source = "../../components/nat"

  name              = "${var.vpc_name}-nat"
  azs               = "${var.azs}"
  public_subnet_ids = "${module.public_subnets.subnet_ids}"
}

module "private_subnets" {
  source = "../../components/private_subnet"

  name            = "${var.private_subnet_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  cidrs           = "${var.private_subnet_cidrs}"
  azs             = "${var.azs}"
  nat_gateway_ids = "${module.nat.nat_gateway_ids}"
}

module "vpc_level_security_groups" {
  source = "../../security_groups/vpc_sgs"

  name                 = "${var.vpc_name}"
  vpc_id               = "${module.vpc.vpc_id}"
  vpc_cidr             = "${var.vpc_cidr}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
}

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "private_subnet_ids" {
  value = "${module.private_subnets.subnet_ids}"
}

output "public_subnet_ids" {
  value = "${module.public_subnets.subnet_ids}"
}

output "igw_id" {
  value = "${module.internet_gateway.igw_id}"
}

output "vpc_allow_all_internal_sg_id" {
  value = "${module.vpc_level_security_groups.vpc_allow_all_internal_id}"
}

output "vpc_allow_all_private_subnets_sg_id" {
  value = "${module.vpc_level_security_groups.vpc_allow_all_private_subnets_id}"
}

output "vpc_allow_all_public_subnets_sg_id" {
  value = "${module.vpc_level_security_groups.vpc_allow_all_public_subnets_id}"
}

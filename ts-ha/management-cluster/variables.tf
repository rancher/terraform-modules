variable "rancher_hostname" {}

variable "aws_region" {}

variable "aws_ami_id" {}

variable "aws_env_name" {}

variable "aws_instance_type" {}

variable "rancher_version" {}

variable "api_ui_version" {}

variable "spot_enabled" {}

variable "health_check_type" {
  default = "EC2"
}

variable "aws_public_subnet_cidrs" {}

variable "aws_private_subnet_cidrs" {}

variable "aws_subnet_azs" {}

variable "database_password" {}

variable "aws_rds_instance_class" {}

variable "vpc_id" {}

variable "aws_private_subnet_ids" {}

variable "aws_public_subnet_ids" {}

variable "aws_key_pair" {}

variable "rancher_com_arn" {}

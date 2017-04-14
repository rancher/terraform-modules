variable "vpc_name" {}

variable "region" {}

variable "vpc_cidr" {}

//These two should be the same length
variable "private_subnet_name" {
  default = "private"
}

variable "public_subnet_name" {
  default = "public"
}

//These three should be the same length
variable "public_subnet_cidrs" {}

variable "private_subnet_cidrs" {}

variable "azs" {}

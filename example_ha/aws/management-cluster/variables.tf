variable "rancher_hostname" {}

variable "domain_name" {}

variable "aws_access_key" {}

variable "aws_secret_key" {}

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

variable "sysdig_key" {

}

variable "cloudflare_token" {
  default = ""
}

variable "cloudflare_email" {
  default = ""
}

variable "aws_key_pair" {
  type    = "string"
  default = "value"
}

variable "vpc_id" {}

variable "name" {}

variable "ami_id" {}

variable "security_groups" {}

variable "spot_enabled" {
  default = "false"
}

variable "instance_type" {
  default = "t2.mediumm"
}

variable "ssh_key_name" {}

variable "lb_ids" {
  default = ""
}

variable "scale_min_size" {
  default = "3"
}

variable "scale_max_size" {
  default = "3"
}

variable "scale_desired_size" {
  default = "3"
}

variable "subnet_cidrs" {}

variable "subnet_ids" {
  default = ""
}

variable "health_check_type" {
  default = "ELB"
}

variable "health_check_target" {
  default = "HTTP:8080/ping"
}

variable "externally_defined_userdata" {
  default = ""
}

variable "userdata" {
  type    = "string"
  default = ""
}

variable "root_volume_size" {
  default = 8
}

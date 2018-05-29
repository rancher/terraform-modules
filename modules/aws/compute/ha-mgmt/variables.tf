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

// Ref: https://github.com/hashicorp/terraform-aws-consul/blob/master/modules/consul-cluster/variables.tf
variable "tags" {
  description = "List fo extra tag blocks added to the autoscaling group configuration. Each element in the list is a map containing keys 'key', 'value', and 'propagate_at_launch' mapped to the respective values."
  type        = "list"
  default     = []
}

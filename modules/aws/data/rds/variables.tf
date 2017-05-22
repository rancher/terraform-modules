variable "vpc_id" {}

variable "rds_instance_class" {}

variable "db_subnet_ids" {
  type = "list"
}

variable "source_cidr_blocks" {
  type = "list"
}

variable "rds_allocated_storage" {
  default = "10"
}

variable "rds_storage_type" {
  default = "standard"
}

variable "rds_instance_name" {
  default = "rancher-db"
}

variable "rds_is_multi_az" {
  default = "true"
}

variable "rds_engine_type" {
  default = "mysql"
}

variable "rds_engine_version" {
  default = "5.6.29"
}

variable "database_name" {
  default = "cattle"
}

variable "database_user" {
  default = "cattle"
}

variable "database_password" {
  default = "cattlepassword"
}

variable "security_group_name" {
  default = "sg_cattle_db"
}

variable "skip_final_snapshot" {
  default = "false"
}

variable "backup_retention_period" {
  default = 1
}

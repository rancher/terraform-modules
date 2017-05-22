//

// Module: tf_aws_rds

//

// RDS Instance Variables

variable "rds_instance_name" {}

variable "rds_is_multi_az" {
  default = "false"
}

variable "rds_storage_type" {
  default = "standard"
}

variable "rds_allocated_storage" {
  description = "The allocated storage in GBs"

  // You just give it the number, e.g. 10
}

variable "rds_engine_type" {
  // Valid types are
  // - mysql
  // - postgres
  // - oracle-*
  // - sqlserver-*
  // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  // --engine
}

variable "rds_engine_version" {
  // For valid engine versions, see:
  // See http://docs.aws.amazon.com/cli/latest/reference/rds/create-db-instance.html
  // --engine-version
}

variable "rds_instance_class" {}

variable "database_name" {
  description = "The name of the database to create"
}

variable "database_user" {}

variable "database_password" {}

variable "rds_security_group_id" {}

variable "db_parameter_group" {
  default = "default.mysql5.6"
}

// RDS Subnet Group Variables
variable "db_subnet_ids" {
  type = "list"
}

variable "skip_final_snapshot" {
  default = "false"
}

variable "backup_retention_period" {
  default = 1
}

module "aws_sg_db" {
  source = "../../network/security_groups/sg_db"

  vpc_id              = "${var.vpc_id}"
  source_cidr_blocks  = "${var.source_cidr_blocks}"
  security_group_name = "${var.security_group_name}"
}

module "aws_database" {
  source = "./db"

  rds_instance_class      = "${var.rds_instance_class}"
  rds_is_multi_az         = "${var.rds_is_multi_az}"
  rds_engine_type         = "${var.rds_engine_type}"
  rds_instance_name       = "${var.rds_instance_name}"
  rds_allocated_storage   = "${var.rds_allocated_storage}"
  rds_storage_type        = "${var.rds_storage_type}"
  rds_engine_version      = "${var.rds_engine_version}"
  database_name           = "${var.database_name}"
  database_user           = "${var.database_user}"
  database_password       = "${var.database_password}"
  db_subnet_ids           = "${var.db_subnet_ids}"
  skip_final_snapshot     = "${var.skip_final_snapshot}"
  backup_retention_period = "${var.backup_retention_period}"

  // dynamic
  rds_security_group_id = "${module.aws_sg_db.security_group_id_database}"
  db_parameter_group    = "${aws_db_parameter_group.default.name}"
}

resource "aws_db_parameter_group" "default" {
  name        = "${var.name}-db-parameter-group"
  family      = "${var.rds_parameter_group_family}"
  description = "RDS Cattle params"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "collation_server"
    value = "utf8_general_ci"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

output "endpoint" {
  value = "${module.aws_database.endpoint}"
}

output "address" {
  value = "${module.aws_database.address}"
}

output "username" {
  value = "${var.database_user}"
}

output "database_name" {
  value = "${var.database_name}"
}

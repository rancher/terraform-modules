//

// Module: tf_aws_rds

//

// This template creates the following resources

// - An RDS instance

// - A database subnet group

// - You should want your RDS instance in a VPC

resource "aws_db_instance" "main_rds_instance" {
  identifier        = "${var.rds_instance_name}"
  allocated_storage = "${var.rds_allocated_storage}"
  engine            = "${var.rds_engine_type}"
  engine_version    = "${var.rds_engine_version}"
  instance_class    = "${var.rds_instance_class}"
  name              = "${var.database_name}"
  username          = "${var.database_user}"
  password          = "${var.database_password}"

  //snapshots and backups
  skip_final_snapshot       = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot     = "${var.skip_final_snapshot == "false" ? "true" : "false" }"
  final_snapshot_identifier = "${format("%s-finalsnapshot", var.rds_instance_name)}"
  backup_retention_period   = "${var.backup_retention_period}"

  // Because we're assuming a VPC, we use this option, but only one SG id
  vpc_security_group_ids = ["${var.rds_security_group_id}"]

  // We're creating a subnet group in the module and passing in the name
  db_subnet_group_name = "${aws_db_subnet_group.main_db_subnet_group.name}"
  parameter_group_name = "${var.db_parameter_group}"

  // We want the multi-az setting to be toggleable, but off by default
  multi_az     = "${var.rds_is_multi_az}"
  storage_type = "${var.rds_storage_type}"

  // Tags
  tags = "${var.tags}"
}

resource "aws_db_subnet_group" "main_db_subnet_group" {
  name        = "${var.rds_instance_name}-subnetgroup"
  description = "RDS subnet group"
  subnet_ids  = ["${var.db_subnet_ids}"]
}

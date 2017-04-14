//

// Module: tf_aws_rds

//

// Output the ID of the RDS instance
output "rds_instance_id" {
  value = "${aws_db_instance.main_rds_instance.id}"
}

// Output the Address of the RDS instance
output "endpoint" {
  value = "${aws_db_instance.main_rds_instance.endpoint}"
}

// Output the ID of the Subnet Group
output "subnet_group_id" {
  value = "${aws_db_subnet_group.main_db_subnet_group.id}"
}

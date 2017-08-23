output "database" {
  value = "${module.database.database_name}"
}

output "password" {
  value = "${var.database_password}"
}

output "username" {
  value = "${module.database.username}"
}

output "endpoint" {
  value = "${module.database.endpoint}"
}

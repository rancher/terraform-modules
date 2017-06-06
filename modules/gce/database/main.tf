resource "google_sql_database_instance" "master" {
  name = "${var.name}"
  region = "${var.region}"
  database_version = "MYSQL_5_6"

  settings {
    tier = "${var.database_tier}"
    disk_size = "${var.disk_size}"
    disk_type = "${var.disk_type}"
  }
}

output "endpoint" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address }"
}

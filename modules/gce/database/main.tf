// GCE Cloud SQL is a MySQL compatible persistence service
resource "google_sql_database_instance" "master" {
  name = "${var.name}"
  region = "${var.region}"
  database_version = "MYSQL_5_6"

  settings {
    tier = "${var.db_tier}"
    disk_size = "${var.disk_size}"
    disk_type = "${var.disk_type}"
    ip_configuration {
            ipv4_enabled = true
            authorized_networks {
                name = "default"
                value = "0.0.0.0/0"
              }
          }
      }
}

resource "google_sql_database" "master" {
    name = "cattle"
    instance = "${google_sql_database_instance.master.name}"
}


resource "google_sql_user" "rancher" {
  name     = "${var.db_user}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "%"
  password = "${var.db_pass}"
}

output "endpoint" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}

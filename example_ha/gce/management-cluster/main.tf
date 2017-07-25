// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gce/credentials")}"
  project     = "rancher-dev"
  region      = "us-central1"
}

resource "random_id" "server" {
   byte_length = 4
}

// Expected to be set at runtime by user
variable "database_endpoint" {}
variable "database_user" {}
variable "database_password" {}
variable "database_name" {}

module "gce_compute" {
  source = "../../../modules/gce/compute"

  name = "rancher-server-${random_id.server.hex}"
  machine_type = "n1-standard-1"
  zone = "us-central1-f"
  server_count = "1"
  service_account_scopes = []
  database_endpoint = "${var.database_endpoint}"
  database_user = "${var.database_user}"
  database_password = "${var.database_password}"
  database_name = "${var.database_name}"
  rancher_version = "stable"
}

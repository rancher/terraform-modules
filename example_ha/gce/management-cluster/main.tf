// Expected to be set at runtime by user
variable "gce_project" {}

variable "gce_region" {}
variable "database_endpoint" {}
variable "database_user" {}
variable "database_password" {}
variable "ssh_pub_key" {}

// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gce/credentials")}"
  project     = "${var.gce_project}"
  region      = "${var.gce_region}"
}

// Get local state from our adjacent terraform module
data "terraform_remote_state" "database" {
  backend = "local"

  config {
    path = "${path.module}/../database/terraform.tfstate"
  }
}

resource "random_id" "server" {
  byte_length = 4
}

module "gce_compute" {
  source = "../../../modules/gce/compute"

  name                                   = "rancher-server-${random_id.server.hex}"
  gce_project                            = "${var.gce_project}"
  machine_type                           = "n1-standard-2"
  zone                                   = "us-central1-f"
  server_count                           = "1"
  service_account_scopes                 = []
  database_endpoint                      = "${var.database_endpoint}"
  database_user                          = "${var.database_user}"
  database_password                      = "${var.database_password}"
  gce-cloud-sql-instance-connection-name = "${var.gce_project}:${var.gce_region}:${data.terraform_remote_state.database.name}"
  rancher_version                        = "stable"
  ssh_pub_key                            = "${var.ssh_pub_key}"
}

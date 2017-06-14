// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gce/credentials")}"
  project     = "rancher-dev"
  region      = "us-central1"
}

// Expected to be set at runtime by user
variable "database_endpoint" {}

resource "random_id" "server" {
   byte_length = 4
}

module "gce_compute" {
  source = "../../../modules/gce/compute"

  name = "rancher-server-${random_id.server.hex}"
  machine_type = "n1-standard-1"
  zone = "us-central1-f"
  server_count = "1"
  service_account_scopes = []
  database_endpoint = "${var.database_endpoint}"
}

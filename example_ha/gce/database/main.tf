// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gce/credentials")}"
  project     = "rancher-dev"
  region      = "us-central1"
}

resource "random_id" "database" {
   byte_length = 4
}

module "gce_database" {
  source = "../../../modules/gce/database"

  name = "rancher-${random_id.database.hex}"
  region = "us-central"
  database_tier = "db-n1-standard-1"
  disk_size = 20
  disk_type = "PD_SSD"
}

output "endpoint" {
  value = "${module.gce_database.endpoint}"
}

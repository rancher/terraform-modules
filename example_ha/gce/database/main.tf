// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gce/credentials")}"
  project     = "rancher-dev"
  region      = "us-central1"
}

module "gce_database" {
  source = "../../../modules/gce/database"

  name = "william-test-db"
  region = "us-central"
  database_tier = "db-n1-standard-1"
  disk_size = 20
  disk_type = "PD_SSD"
}

// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("~/.gce/credentials")}"
  project     = "rancher-dev"
  region      = "us-central1"
}


module "gce_compute" {
  source = "../../../modules/gce/compute"

  name = "william-test"
  machine_type = "n1-standard-1"
  zone = "us-central1-f"
  disk_image = "ubuntu-os-cloud/ubuntu-1604-lts"
  server_count = "1"
  service_account_scopes = []
  database_endpoint = ""
}

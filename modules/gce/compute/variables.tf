variable "name" {}
variable "machine_type" {}
variable "zone" {}
variable "disk_image" {}
variable "server_count" {
  default = "1"
}
variable "compute_count" {
  default = "1"
}
variable "server_metadata_startup_script" {
  //default = "${file("metadata_scripts/server.sh")}"
  default = ""
}
variable "compute_metadata_startup_script" {
  //default = "${file("metadata_scripts/compute.sh")}"
  default = ""
}
variable "service_account_scopes" {
  type = "list"
}

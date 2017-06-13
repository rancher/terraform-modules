variable "name" {}
variable "region" {}
variable "database_tier" {}
variable "disk_size" {}
variable "disk_type" {}
variable "db_user" {
  default = "rancher"
}
variable "db_pass" {
  default = "r@nch3r!#!"
}

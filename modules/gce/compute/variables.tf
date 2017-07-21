variable "name" {}
variable "machine_type" {}
variable "zone" {}
variable "server_count" {
  default = "1"
}

variable "service_account_scopes" {
  type = "list"
}

variable "instance_metadata" {
  type = "map"
  default = {}
}
variable "instance_zone" {
  default = "us-central1-a"
}

variable "instance_tags"  {
  type = "list"
  default = []
}
variable "database_endpoint" {
  default = ""
}

variable "database_name" {
  default = ""
}

variable "database_user" {
  default = ""
}

variable "database_password" {
  default = ""

}
variable "docker_version" {
  default = "docker-1.12.6"
}

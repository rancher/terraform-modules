# Expects this variable to be set as environment variable TF_VAR_digitalocean_token or through CLI
# see https://www.terraform.io/docs/configuration/variables.html
variable "digitalocean_token" {}

variable "instance_type" {
  default = "node"
}

variable "docker_cmd" {}

variable "ssh_keys" {
  type = "list"
}

variable "node_count" {
  default = 1
}

variable "do_region" {
  default = "sfo1"
}

variable "do_droplet_size" {
  default = "2gb"
}

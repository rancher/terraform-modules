variable "digitalocean_token" {}

variable "rancher_version_tag" {
  default = "stable"
}

variable "ssh_keys" {
  type = "list"
}

module "digital-ocean" {
  source = "../../modules/do/compute"
  node_count = 1
  digitalocean_token = "${var.digitalocean_token}"
  docker_cmd = "docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:${var.rancher_version_tag}"
  ssh_keys = "${var.ssh_keys}"
  instance_type = "server"
}


output "server-ip" {
  value = "${module.digital-ocean.server-ip}"
}

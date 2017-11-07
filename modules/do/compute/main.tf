# Configure the DigitalOcean Provider
provider "digitalocean" {
    token = "${var.digitalocean_token}"
}

data "template_file" "user_data" {
    template = "${file("${path.module}/user-data-ubuntu.tpl")}"
    vars {
        hostname-prefix = "${var.instance_type}"
        docker_cmd = "${var.docker_cmd}"
    }
}

resource "digitalocean_droplet" "rancher_instance" {
    count = "${var.node_count}"
    image = "ubuntu-16-04-x64"
    name = "rancher-${var.instance_type}-${count.index}"
    region = "${var.do_region}"
    size = "${var.do_droplet_size}"
    backups = false
    ipv6 = false
    private_networking = false
    user_data = "${data.template_file.user_data.rendered}"
    ssh_keys = "${var.ssh_keys}"
}


output "server-ip" {
  value = "${digitalocean_droplet.rancher_instance.ipv4_address}"
}

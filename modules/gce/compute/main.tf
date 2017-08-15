// RancherOS Image
resource "google_compute_image" "rancheros" {
  name = "rancheros"
  raw_disk {
    source = "https://storage.googleapis.com/releases.rancher.com/os/v1.0.3/rancheros-v1.0.3.tar.gz"
    sha1 = "e151a5fab00a7ee83c9f9589a42a3fbb833043c1"
  }
}

// Rancher Server Node
resource "google_compute_instance_group_manager" "rancher-servers" {
  name        = "${var.name}-rancher-servers"
  description = "Rancher Servers Instance Group Manager"

  base_instance_name = "${var.name}-server"
  instance_template  = "${google_compute_instance_template.rancher-servers.self_link}"
  update_strategy    = "NONE"
  zone               = "${var.instance_zone}"

  target_pools = ["${google_compute_target_pool.rancher-servers.self_link}"]
  target_size  = "${var.server_count}"

  named_port {
    name = "rancher-api"
    port = 8080
  }
}

resource "google_compute_http_health_check" "rancher-servers" {
  name         = "rancher-server-health-check"
  description = "Health check for Rancher Server instances"
  request_path = "/v1/scripts/api.crt"
  port = "8080"

  timeout_sec        = 2
  check_interval_sec = 30
  unhealthy_threshold = 2
}

resource "google_compute_target_pool" "rancher-servers" {
  name = "rancher-servers-target"
  description = "Target pool for Rancher Servers"
  depends_on = ["google_compute_http_health_check.rancher-servers"]

  health_checks = [
    "${google_compute_http_health_check.rancher-servers.name}",
  ]
  // Options are "NONE" (no affinity). "CLIENT_IP" (hash of the source/dest addresses / ports), and "CLIENT_IP_PROTO" also includes the protocol (default "NONE").
  session_affinity = "NONE"
}


data "template_file" "userdata" {
  template = "${file("${path.module}/files/userdata.template")}"

  vars {
    database_endpoint = "${var.database_endpoint}"
    database_user     = "${var.database_user}"
    database_password = "${var.database_password}"
    rancher_version   = "${var.rancher_version}"
    docker_version    = "${var.docker_version}"
    gce-cloud-sql-instance-connection-name = "${var.gce-cloud-sql-instance-connection-name}"
    ssh_pub_key = "${var.ssh_pub_key}"
  }
}

resource "google_compute_instance_template" "rancher-servers" {
  name         = "${var.name}-server"
  description = "Template for Rancher Servers"

  tags = ["${var.instance_tags}", "rancher-servers", "created-by-terraform"]

  machine_type = "${var.machine_type}"
  instance_description = "Instance running Rancher Server"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = "${google_compute_image.rancheros.self_link}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  service_account {
   scopes = [ "compute-ro", "storage-ro", "cloud-platform"]
  }

  metadata = "${var.instance_metadata}"

  metadata_startup_script = "${data.template_file.userdata.rendered}"
}

resource "google_compute_forwarding_rule" "rancher-servers" {
  name       = "rancher-servers-forwarder"
  description = "Externally facing forwarder for Rancher servers"
  target     = "${google_compute_target_pool.rancher-servers.self_link}"
  ip_protocol = "TCP"
  port_range = "80-8080"
  load_balancing_scheme = "EXTERNAL"
}

resource "google_compute_firewall" "default" {
  name    = "tf-rancher-servers-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rancher-servers"]
}

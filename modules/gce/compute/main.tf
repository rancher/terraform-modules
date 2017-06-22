// RancherOS Image
resource "google_compute_image" "rancheros" {
  name = "rancheros"
  raw_disk {
    source = "https://storage.googleapis.com/releases.rancher.com/os/v1.0.0/rancheros-v1.0.0.tar.gz"
    sha1 = "24451c0624c2c2de108ad78ee93f8b5633526f19"
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

resource "google_compute_health_check" "rancher-servers" {
  name = "rancher-servers"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "8080"
  }
}


resource "google_compute_target_pool" "rancher-servers" {
  name = "rancher-servers-target"
  depends_on = ["google_compute_health_check.rancher-servers"]

  # Need to revisit why this isn't working, it tries to lookup an HTTP load balancer
  # health_checks = [
  #   "${google_compute_health_check.rancher-servers.name}",
  # ]
}


resource "google_compute_instance_template" "rancher-servers" {
  name         = "${var.name}-server"
  description = "Template for Rancher Servers"

  tags = ["${var.instance_tags}", "rancher-servers"]

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

  }

  metadata = "${var.instance_metadata}"

  metadata_startup_script = "${file("${path.module}/metadata_scripts/server.sh")}"


  service_account {
    scopes = ["${var.service_account_scopes}"]
  }
}

resource "google_compute_forwarding_rule" "rancher-servers" {
  name       = "test"
  target     = "${google_compute_target_pool.rancher-servers.self_link}"
  port_range = "80"
}

resource "google_compute_firewall" "default" {
  name    = "tf-rancher-servers-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["rancher-servers"]
}

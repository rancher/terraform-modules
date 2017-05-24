// Rancher server node
resource "google_compute_instance_group_manager" "rancher-servers" {
  name        = "${var.name}"
  description = "Terraform test instance group manager"

  base_instance_name = "${var.name}-server"
  instance_template  = "${google_compute_instance_template.rancher-servers.self_link}"
  update_strategy    = "NONE"
  zone               = "us-central1-a"

  target_pools = ["${google_compute_target_pool.rancher-servers.self_link}"]
  target_size  = "${var.server_count}"

  named_port {
    name = "rancher-api"
    port = 8888
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
  name = "test"
  depends_on = ["google_compute_health_check.rancher-servers"]

  # Need to revisit why this isn't working, it tries to lookup an HTTP load balancer
  # health_checks = [
  #   "${google_compute_health_check.rancher-servers.name}",
  # ]
}

resource "google_compute_instance_template" "rancher-servers" {
  name         = "${var.name}-server"
  description = "template description"

  tags = ["foo", "bar"]
  machine_type = "${var.machine_type}"
  instance_description = "description assigned to instances"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }


  disk {
    source_image = "${var.disk_image}"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {}

  metadata_startup_script = "${var.server_metadata_startup_script}"


  service_account {
    scopes = ["${var.service_account_scopes}"]
  }
}

resource "google_compute_forwarding_rule" "rancher-servers" {
  name       = "test"
  target     = "${google_compute_target_pool.rancher-servers.self_link}"
  port_range = "80"
}

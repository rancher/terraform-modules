// Rancher server node
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

  tags = "${var.instance_tags}"
  machine_type = "${var.machine_type}"
  instance_description = "Instance running Rancher Server"
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

// Rancher compute node
//
//

resource "google_compute_instance_group_manager" "rancher-compute" {
  name        = "${var.name}-rancher-compute"
  description = "Rancher Compute Instance Group Manager"

  base_instance_name = "${var.name}-compute"
  instance_template  = "${google_compute_instance_template.rancher-compute.self_link}"
  update_strategy    = "NONE"
  zone               = "${var.instance_zone}"

  target_pools = ["${google_compute_target_pool.rancher-servers.self_link}"]
  target_size  = "${var.server_count}"

  named_port {
    name = "rancher-api"
    port = 8080
  }
}

resource "google_compute_health_check" "rancher-compute" {
  name = "rancher-compute"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "8080"
  }
}


resource "google_compute_target_pool" "rancher-compute" {
  name = "rancher-compute-target"
  depends_on = ["google_compute_health_check.rancher-compute"]

  # Need to revisit why this isn't working, it tries to lookup an HTTP load balancer
  # health_checks = [
  #   "${google_compute_health_check.rancher-servers.name}",
  # ]
}

resource "google_compute_instance_template" "rancher-compute" {
  name         = "${var.name}-compute"
  description = "Template for Rancher Compute Nodes"

  tags = "${var.instance_tags}"
  machine_type = "${var.machine_type}"
  instance_description = "Instance running Rancher Compute Nodes"
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

  }

  metadata = "${var.instance_metadata}"

  metadata_startup_script = "${file("${path.module}/metadata_scripts/compute.sh")}"


  service_account {
    scopes = ["${var.service_account_scopes}"]
  }
}

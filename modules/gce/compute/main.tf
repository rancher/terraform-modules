// Rancher server node
resource "google_compute_instance" "rancher_server" {
  count        = "${var.server_count}"
  name         = "${var.name}-server"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  tags = ["rancher_server"]

  disk {
    image = "${var.disk_image}"
  }

  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {}

  metadata_startup_script = "${var.server_metadata_startup_script}"
  //metadata_startup_script = "docker run -d --restart=unless-stopped -p 8080:8080 --name=rancher-server rancher/server:stable"

  service_account {
    scopes = ["${var.service_account_scopes}"]
  }
}

// Rancher compute node
resource "google_compute_instance" "rancher_compute" {
  count        = "${var.compute_count}"
  name         = "${var.name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  tags = ["rancher_server"]

  disk {
    image = "${var.disk_image}"
  }

  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata {}

  metadata_startup_script = "${var.compute_metadata_startup_script}"

  service_account {
    scopes = ["${var.service_account_scopes}"]
  }
}

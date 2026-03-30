# Compute Module

resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "projects/${var.project_id}/global/networks/${var.network_name}"
    subnetwork = var.subnet_name != "" ? "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnet_name}" : null

    access_config { }
  }
}
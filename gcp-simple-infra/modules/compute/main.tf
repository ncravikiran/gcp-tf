resource "google_compute_instance" "vm" {
  name         = var.vm_name
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name

    access_config {
      // Public IP
    }
  }

  metadata_startup_script = file("${path.module}/../../startup-script.sh")
}
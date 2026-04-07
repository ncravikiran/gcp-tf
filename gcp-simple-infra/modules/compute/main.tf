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
  metadata_startup_script = var.startup_script
}

resource "google_service_account" "vm_sa" {
  account_id   = "vm-secret-accessor"
  display_name = "VM Secret Manager Accessor"
}

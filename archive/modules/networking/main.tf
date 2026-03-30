# Networking Module

# Configure networking resources in GCP

resource "google_compute_network" "default" {
  count = var.create_network ? 1 : 0

  name                    = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
}
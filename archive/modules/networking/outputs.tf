output "network_name" {
  value = var.create_network ? google_compute_network.default[0].name : var.network_name
}

# Add other networking module outputs as needed
# Main Terraform configuration to orchestrate resources

module "networking" {
  source        = "./modules/networking"
  network_name  = var.network_name
  create_network = false
}

module "compute" {
  source         = "./modules/compute"
  instance_name  = var.instance_name
  machine_type   = var.machine_type
  zone           = var.zone
  network_name   = var.network_name
  subnet_name    = var.subnet_name
  region         = var.region
  project_id     = var.project_id
}

module "state_bucket" {
  source      = "./modules/state-bucket"
  bucket_name = var.bucket_name
  region      = var.region
}
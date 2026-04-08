module "networking" {
  source      = "../../modules/networking"
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  region      = var.region
}

module "compute" {
  source          = "../../modules/compute"
  vm_name         = var.vm_name
  project_id      = var.project_id
  vm_machine_type = var.vm_machine_type
  zone            = var.zone
  network_name    = module.networking.network_name
  subnet_name     = module.networking.subnet_name

  startup_script = file("${path.module}/startup-script.sh")

}

module "storage" {
  source      = "../../modules/storage"
  bucket_name = var.bucket_name
  region      = var.region
}

module "database" {
  source = "../../modules/database"

  project_id          = var.project_id
  region              = var.region
  db_instance_name    = var.db_instance_name
  db_name             = var.db_name
  db_user             = var.db_user
  db_password         = var.db_password
  authorized_networks = var.authorized_networks
}

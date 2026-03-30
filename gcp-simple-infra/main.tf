module "networking" {
  source      = "./modules/networking"
  vpc_name    = var.vpc_name
  subnet_name = var.subnet_name
  region      = var.region
}

module "compute" {
  source       = "./modules/compute"
  vm_name      = var.vm_name
  zone         = var.zone
  network_name = module.networking.network_name
  subnet_name  = module.networking.subnet_name
}

module "storage" {
  source      = "./modules/storage"
  bucket_name = var.bucket_name
  region      = var.region
}
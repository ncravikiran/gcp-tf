# Main Terraform configuration to orchestrate resources

module "networking" {
  source = "./modules/networking"
}

module "compute" {
  source = "./modules/compute"
}

module "state_bucket" {
  source = "./modules/state-bucket"
}
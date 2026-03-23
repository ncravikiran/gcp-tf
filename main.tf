# Terraform Configuration for GCP Infrastructure

## Root Module

### main.tf
provider "google" {
  project = var.project_id
  region  = var.region
}

module "networking" {
  source = "./modules/networking"
  project_id = var.project_id
  region     = var.region
}

module "compute" {
  source = "./modules/compute"
  project_id = var.project_id
  region     = var.region
  machine_type = var.machine_type
}

module "state_bucket" {
  source = "./modules/state_bucket"
  project_id = var.project_id
  region     = var.region
}

output "network_name" {
  value = module.networking.network_name
}

### variables.tf
variable "project_id" {
  description = "The ID of the project"
  type        = string
}

variable "region" {
  description = "The region in which resources will be provisioned"
  type        = string
  default     = "us-west1"
}

variable "machine_type" {
  description = "The type of machine to create"
  type        = string
  default     = "e2-medium"
}

### outputs.tf
output "instance_id" {
  value = module.compute.instance_id
}

### terraform.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.5"
    }
  }
  required_version = ">= 0.12"
}

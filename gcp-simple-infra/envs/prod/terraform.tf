terraform {
  backend "gcs" {
    bucket = "prod-bucket-test-rk"
    prefix = "terraform/prod/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
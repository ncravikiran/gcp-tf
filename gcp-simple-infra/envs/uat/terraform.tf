terraform {
  backend "gcs" {
    bucket = "uat-bucket-test-rk"
    prefix = "terraform/uat/state"
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
terraform {
  backend "gcs" {
    bucket = "tf-bucket-test-rk"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.1"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

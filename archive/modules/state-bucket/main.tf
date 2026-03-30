# State Bucket Module

resource "google_storage_bucket" "default" {
  name     = var.bucket_name
  location = var.region
  uniform_bucket_level_access = true
  # other configurations
}
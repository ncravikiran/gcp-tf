# GCS Backend configuration

terraform {
  backend "gcs" {
    bucket      = "<your-gcs-bucket-name>"
    prefix      = "tf/state"
    credentials = "<path-to-your-service-account-key>"
  }
}
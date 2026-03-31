# Project Documentation

# GCP Terraform Project

This project contains Terraform configurations for provisioning GCP resources.

## Modules

- networking
- compute
- state-bucket

## Usage

This repository now uses a GCS backend for Terraform state. Set the GitHub secret `TF_STATE_BUCKET` to your GCS bucket name and ensure the authenticated service account has access to that bucket.

Run the following commands to initialize and apply the Terraform configurations:

```bash
terraform init
terraform apply

terraform plan -out=tfplan
terraform apply tfplan

```
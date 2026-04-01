variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-west1-a"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "my-subnet"
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "my-vm"
}

variable "bucket_name" {
  description = "Name of the storage bucket"
  type        = string
  default     = "my-bucket"
}
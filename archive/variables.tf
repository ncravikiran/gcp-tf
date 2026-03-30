variable "project_id" {
  description = "Project ID for the GCP project"
  type        = string
}

variable "region" {
  description = "The region for GCP resources"
  type        = string
}

variable "zone" {
  description = "The zone for GCP resources"
  type        = string
}

variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the compute instance"
  type        = string
}

variable "network_name" {
  description = "Name of the networking resource"
  type        = string
}

variable "subnet_name" {
  description = "Name of the existing subnet (or empty to skip subnetwork attachment)"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "Name of the storage bucket for state"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "vm_machine_type" {
  description = "Machine type for the VM"
  type        = string
}

variable "vm_disk_size" {
  description = "Disk size for the VM in GB"
  type        = number
}

variable "enable_external_ip" {
  description = "Enable external IP for the compute instance"
  type        = bool
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
}
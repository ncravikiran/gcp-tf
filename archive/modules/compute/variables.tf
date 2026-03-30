variable "instance_name" {
  description = "Name of the compute instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the compute instance"
  type        = string
}

variable "zone" {
  description = "The zone for the compute instance"
  type        = string
}

variable "network_name" {
  description = "Name of the network to attach to the instance"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnetwork to attach to the instance"
  type        = string
  default     = ""
}

variable "region" {
  description = "Region of the subnetwork/instance"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = ""
}

# Add other compute variables as needed
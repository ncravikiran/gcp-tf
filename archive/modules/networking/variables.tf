variable "network_name" {
  description = "Name of the networking resource"
  type        = string
}

variable "create_network" {
  description = "Whether to create the network resource. Set false to use an existing network."
  type        = bool
  default     = true
}

variable "auto_create_subnetworks" {
  description = "Whether to auto-create subnetworks for the new network"
  type        = bool
  default     = false
}

# Add other networking module variables as needed
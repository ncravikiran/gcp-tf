variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "db_instance_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "authorized_networks" {
  description = "List of CIDR blocks allowed to connect"
  type        = list(string)
}

variable "bucket_name" {
  description = "Name of the storage bucket for state"
  type        = string
}

variable "region" {
  description = "The region for the storage bucket"
  type        = string
}

# Add other state bucket variables as needed
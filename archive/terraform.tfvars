# Example of terraform variables defined in the .tfvars file
project_id = "project-9cb824fe-f85e-4763-8bb"  # Your project ID
region     = "us-west1"
zone       = "us-west1-a"
network_name = "my-vpc"
subnet_name = "public-subnet-1"
vpc_cidr   = "10.0.0.0/16"
subnet_cidr = "10.0.0.0/24"
vm_machine_type = "e2-medium"
vm_disk_size = 20
enable_external_ip = false
allowed_ssh_cidr = ["0.0.0.0/0"]  # Change from 0.0.0.0/0 for security
environment = "dev"
common_labels = {
  environment = "dev"
  managed_by  = "terraform"
  team        = "devops"
  project     = "gcp-infrastructure"
}
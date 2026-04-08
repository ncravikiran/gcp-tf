project_id = "project-9cb824fe-f85e-4763-8bb"
# Change defaults here if needed
vpc_name            = "tf-vpc"
subnet_name         = "my-tf-subnet"
vm_name             = "tf-vm"
vm_machine_type     = "e2-medium"
bucket_name         = "tf-bucket-test-rk"
db_instance_name    = "qa-postgres"
db_name             = "qa_app_db"
db_user             = "qa_app_user"
db_password         = "TEMP_REPLACE_FROM_SECRET_MANAGER"
authorized_networks = ["0.0.0.0/0"]

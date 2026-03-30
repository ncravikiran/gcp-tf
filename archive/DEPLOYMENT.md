# Deployment Guide

## Prerequisites
- Access to the GCP Console
- Familiarity with Terraform
- Necessary IAM permissions for resource management

## Step-by-Step Deployment Instructions
1. **Clone the Repository**:  
   ```bash
   git clone https://github.com/ncravikiran/gcp-tf.git
   cd gcp-tf
   ```  

2. **Initialize Terraform**:  
   ```bash
   terraform init
   ```  

3. **Configure Your Variables**:  
   Edit the `variables.tf` file to set your environment-specific variables.

4. **Plan the Deployment**:  
   ```bash
   terraform plan
   ```  
   This step allows you to review what Terraform will create.

5. **Apply the Deployment**:  
   ```bash
   terraform apply
   ```  
   Confirm the action by typing 'yes'.

## Useful Commands
- `terraform destroy` - To tear down all resources created by Terraform.
- `terraform fmt` - To format Terraform files to a canonical format.
- `terraform validate` - To validate the configuration files.

## SSH Access Guidance
- Ensure your SSH public key is added to the project metadata in GCP.
- Use the following command to SSH into your resources:  
   ```bash
   gcloud compute ssh <INSTANCE_NAME>
   ```

## Troubleshooting Tips
- If you encounter issues, check the logs in the GCP console under the respective resources.
- Ensure that all IAM roles are correctly assigned.
- Validate your Terraform configuration files and ensure there are no errors.

## Security Best Practices
- Regularly update your IAM roles and permissions.
- Use Service Accounts for automation tasks and limit permissions as much as possible.
- Regularly audit your deployed resources and configurations.
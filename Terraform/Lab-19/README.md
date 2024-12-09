# Lab 19: Remote Backend and LifeCycle Rules  

## Objective  

1. Implement the provided architecture diagram using Terraform.  
2. Store the Terraform state file in a remote backend.  
3. Configure a `create_before_destroy` lifecycle rule for an EC2 instance and verify its behavior.  
4. Compare different Terraform lifecycle rules and their impacts.  

---

## Steps  

### 1. Pre-requisites  

1. **Set Up Remote Backend**:  
   - Define an S3 bucket 

   ![image](https://github.com/user-attachments/assets/cc4b6cce-ee16-4fbf-a4de-af1552d4635b)

   - Define DynamoDB table for the Terraform remote backend.
   
   ![image](https://github.com/user-attachments/assets/ce298c87-7e9e-4177-8a6a-aece0a6101af)

2. **Configure Remote Backend**:  

```
terraform {
  backend "s3" {
    bucket = "state-file-bucket-11-10-2024"
    key    = "terraform-file-state.tfstate"
    region = "us-east-1"
    dynamodb_table = "Lock_users"
  }
}

```

---

### 2. Project Structure  

Organize the project directory as follows:




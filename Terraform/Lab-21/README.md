
# Lab 21: Terraform Proxy Servers  

![Upload](https://github.com/user-attachments/assets/5de1c48b-71fb-4b34-a111-5e578965c01e)

## Objective  

1. Create a new Terraform workspace named `ivolve`.  
2. Implement the provided architecture diagram using Terraform modules.  
3. Output the public IP of the Load Balancer (LB) and include a screenshot demonstrating successful access to the LB.  
4. Avoid code repetition by using variables and modules.  

---

## Steps  

### 1. Create a New Workspace  

1. **Initialize the Project Directory**:  
   - Create and navigate to the project directory:  

     ```bash
     mkdir Lab-21 && cd Lab-21
     terraform init
     ```  

2. **Create the Workspace**:  
   - Create and switch to a new workspace named `ivolve`:
       
     ```bash
     terraform workspace new ivolve
     ```  
---
### 2. Project Structure

    ```plaintext
    Lab-21/
    │ └── provider.tf
    │ └── main.tf  
    modules/
      ├── compute
      │    └── main.tf
      │    └── variables.tf
      │    └── terraform.tfvars
      │    └── outputs.tf
      ├── networking
      │    └── main.tf
      │    └── variables.tf
      │    └── terraform.tfvars
      │    └── outputs.tf
      ├── loadbalancer
      │    └── main.tf
      │    └── variables.tf
      │    └── terraform.tfvars
      │    └── outputs.tf
      ├── security_groups
      │    └── main.tf
      │    └── variables.tf
      │    └── terraform.tfvars
      │    └── outputs.tf
    ```
### 3. Define Modules

#### **Module 1: compute**  

Handles EC2 instance provisioning:
- Instance type: t2.micro
- Instances in both public and private subnets
- Integration with load balancers
  
#### **Module 2: networking**  

Configures the base network infrastructure:
- VPC with CIDR: 10.0.0.0/16
- Public subnets: 10.0.1.0/24, 10.0.3.0/24
- Private subnets: 10.0.0.0/24, 10.0.2.0/24
- Availability zones: us-east-1a, us-east-1b

  
#### **Module 3: security_groups**  

Manages security group configurations:
- Proxy security groups
- HTTP security groups
- Load balancer security groups
  
#### **Module 4: loadbalancer**  

Configures load balancers:
- External load balancer in public subnets
- Internal load balancer in private subnets
- Health checks and target group configurations

### Request Flow

1. The user request enters the public-facing load balancer.
2. The load balancer routes the request to the proxy security group and instances.
3. The proxy tier handles routing and traffic management, forwarding the request to the private HTTP security group and instances.
4. The HTTP tier processes the application logic and generates a response. 
5. The response is sent back through the proxy tier to the external load balancer.
6. The load balancer delivers the response to the user.


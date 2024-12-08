
# Lab 17: Multi-Tier Application Deployment with Terraform  

## Objective  
1. Create a `ivolve` VPC manually in AWS and use a Data block in Terraform to retrieve the VPC ID.  
2. Define and deploy a multi-tier architecture using Terraform that includes:  
   - Two subnets (public and private).  
   - An EC2 instance.  
   - An RDS database.  
3. Use a local provisioner to save the EC2 public IP address into a file named `ec2-ip.txt`.  

---
## Required Installation 

1. Add the HashiCorp GPG Key
   
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

2. Add the HashiCorp Repository

```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

3. Update the System

```
sudo apt update
```

4. Install Terraform

```
sudo apt install terraform
```

## Steps  

### 1. Pre-requisites  

1. **Manually Create the VPC**:  
   - Use the AWS Management Console to create a VPC named `ivolve`.  
   - Note the region and ensure you have access credentials configured for Terraform.  

  ![image](https://github.com/user-attachments/assets/631bae5c-d12b-49b2-a25b-aafd694de29d)

2. **Initialize Terraform**:  
   - Create a directory for the Terraform project and navigate into it:
     
     ```bash
     mkdir -p Terraform/Lab-17 && cd Terraform/Lab-17
     ```  

   - Initialize Terraform:  
     ```bash
     terraform init
     ```  

---

### 2. Retrieve VPC ID

1. **Define a Data Block in `main.tf`**:  
   Add the following to fetch the VPC ID:  

 ```
   data "aws_vpc" "by_tag" {
     tags = {
        Name = "ivolve-vpc"
      }
    }
 ```
### 3. Define Subnets

#Create a Public Subnet

```
resource "aws_subnet" "Public-1" {
  vpc_id     = data.aws_vpc.by_tag.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-1"
  }
}
```

#Create a Private SUbnet

```
resource "aws_subnet" "Private-1" {
  vpc_id     = data.aws_vpc.by_tag.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private-1"
  }
}
```
### 4. Define the Network Configuration

1. **Define an Internet Gateway in `main.tf`**:

```
  resource "aws_internet_gateway" "ivolve-igw" {
  vpc_id = data.aws_vpc.by_tag.id
  tags = {
    Name = "ivolve-igw"
    }
  }
```
2. **Define a route table in `main.tf`**:

```
  resource "aws_route_table" "ivolve-rt" {
  vpc_id = data.aws_vpc.by_tag.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ivolve-igw.id
  }
  tags = {
    Name = "ivolve-rt"
  }
}
```


3. **Associate the Public Subnet to the route table**:

```
  resource "aws_route_table" "ivolve-rt" {
  vpc_id = data.aws_vpc.by_tag.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ivolve-igw.id
  }
  tags = {
    Name = "ivolve-rt"
  }
}
```
### 5. Define the Security Groups

1. **Define the Security Group for the EC2**:


---



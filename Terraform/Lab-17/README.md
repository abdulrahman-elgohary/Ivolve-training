
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

```
resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.by_tag.id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-sg"
  }
}

```

2. **Define the Security Group for ALB**:

```
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.by_tag.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups =  [aws_security_group.ec2-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-sg"
  }
}
```
---

### 6. Define the EC2 Resource 

```
resource "aws_instance" "ec2-1" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Public-1.id
  security_groups = [aws_security_group.ec2-sg.id]
  tags = {
    Name = "ec2-1"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }

}
```

### 7. Define the database subnet group

```
resource "aws_db_subnet_group" "rds-subnet" {
  name       = "rds-subnet"
  subnet_ids = [aws_subnet.Private-1.id , aws_subnet.Public-1.id]
  tags = {
    Name = "rds-subnet"
  }
}
```

### 8. Create the database

```
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20                       # Storage size in GB
  engine               = "mysql"                  # Replace with your desired engine (e.g., "postgres",
  engine_version       = "8.0.39"                 # Specific version of the engine
  instance_class       = "db.t3.micro"            # RDS instance type
  username             = "admin"                  # Master username
  password             = "Password123" # Master password
  parameter_group_name = "default.mysql8.0"       # Replace with your engine's default parameter group
  publicly_accessible  = true                     # Set false for private instances
  skip_final_snapshot  = true                     # Avoid snapshot on deletion for testing
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet.name
}

```


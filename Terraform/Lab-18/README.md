
# Lab 18: Terraform Modules  

## Objective  

1. Create a VPC with two public subnets defined in the `main.tf` file.  
2. Create a Terraform module to deploy an EC2 instance with Nginx installed via user data.  
3. Use the EC2 module to deploy one instance in each subnet.  

---

## Steps  

### 1. Define VPC and Subnets  

**Add VPC and Subnet Configuration in `main.tf`**:  
```
#Create a Vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "vpc-Lab-18"
  }
}

#Create an Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-Lab-18"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnet" {
  count = 2 
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

#Create a Route Table 
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rt-Lab-18"
  }
}

#Associate Subnets with Route Table
resource "aws_route_table_association" "rt_association" {
  count = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt.id
}
```

### 2.Create EC2 Module

1. **Configure the Ec2 in main.tf**

``` 
resource "aws_instance" "Nginx-Instance" { 
  ami           = data.aws_ami.Amazon-linux-ami.id
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.sg_ec2]
  key_name = "Test"
  user_data =  <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF
  tags = {
    Name = "Nginx-Ec2"
  }

}

```
2. **Add the variables inside the module directory**

```

variable "subnet_id" {}

data "aws_ami" "Amazon-linux-ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

variable "sg_ec2" {
  type = string
}

```

### 3. Use the EC2 Module in main.tf

```
#Create an Ec2 in each Subnet

module "ec2_subnet" {
  count = 2
  source = "./modules/compute"
  sg_ec2 = aws_security_group.sg_nginx_tr.id
  subnet_id = aws_subnet.public_subnet[count.index].id
}

```

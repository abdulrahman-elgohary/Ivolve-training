# Lab 20: Terraform Variables and Loops  

## Objective  

1. Implement the provided architecture diagram using Terraform, leveraging variables for all arguments to avoid code repetition.  
2. Use a remote provisioner to install Nginx and Apache on EC2 instances.  
3. Create a NAT Gateway manually and then import it into Terraform for management using `terraform import`.  
4. Output the public and private IPs of the EC2 instances.  

---

## Steps  

### 1. Define Variables 
```
variable "vpc_cidr" {
    type = string
}

variable "subnet_cidrs" {
    type = list(string)
}

variable "availability_zones" {
    type = list(string)
}

variable "map_value" {
    type = list(string)
}

variable "subnet_name" {
    type = list(string)
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS account ID
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"] # Example for Ubuntu 20.04
  }
}

variable "aws_ec2_size" {
  type = string
}

variable "key" {
    type = string
}

```
---

### 2. Define the value of the variables in terraform.tfvars

```
vpc_cidr = "10.0.0.0/16"

subnet_cidrs = ["10.0.1.0/24" , "10.0.2.0/24"]

availability_zones = [ "us-east-1a" , "us-east-1b"]

aws_ec2_size = "t2.micro"

key = "Project1_Key"

map_value = [ "true" , "false" ]

subnet_name = [ "public" , "private" ]

```


### 3. Create the VPC Manually then Import it inside the main.tf

![image](https://github.com/user-attachments/assets/e3a4b960-eea9-415a-9b3d-7ee9b754a4cc)

```bash
terraform import aws_vpc.custom_vpc <vpc-id>
```

### 4. Define the Network Resources
```
#Create a VPC 
resource "aws_vpc" "custom_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true 
  enable_dns_hostnames = true

  tags = {
    Name = "custom_vpc"
  }
 

}

#Create a Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom_igw"
  }
}

#Create a Elastic IP Address
resource "aws_eip" "custom_eip" {


  tags = {
    Name = "custom_eip"
  }
}

#Create a Nat Gateway 
resource "aws_nat_gateway" "custom_nat" {
  allocation_id = aws_eip.custom_eip.id
  subnet_id     = aws_subnet.custom_subnets[0].id

  tags = {
    Name = "custom_nat"
  }
}


#Create Public Subnet

resource "aws_subnet" "custom_subnets" {
  count = 2
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_value[count.index]
  tags = {
    Name = "custom_${var.subnet_name[count.index]}_subnet"
  }
}

#Create a Route Table
resource "aws_route_table" "custom_rt" {
  count = 2
  vpc_id = aws_vpc.custom_vpc.id

  dynamic "route" {
    for_each = count.index == 0  ? [ { cidr_block = "0.0.0.0/0", gateway_id = aws_internet_gateway.custom_igw.id } ] : [ { cidr_block = "0.0.0.0/0", nat_gateway_id = aws_nat_gateway.custom_nat.id } ]
    content {
      cidr_block    = route.value.cidr_block
      gateway_id    = lookup(route.value, "gateway_id", null)
      nat_gateway_id = lookup(route.value, "nat_gateway_id", null)
    }
  }

  tags = {
    Name = count.index == 0 ? "public_rt" : "private_rt"
  }
}

#Associate Public Subnet to the route table 
resource "aws_route_table_association" "public_subnet_association" {
  count = 2
  subnet_id      = aws_subnet.custom_subnets[count.index].id
  route_table_id = aws_route_table.custom_rt[count.index].id
}

#Create a Security Group for Public Ec2
resource "aws_security_group" "custom_sg" {
  name        = "custom_sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
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
    Name = "custom_sg"
  }
}
```

---

### 5. Define the Computing Resources 

```
#Create a Security Group for Private Ec2
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.custom_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_sg"
  }
}
#Create Ec2 
resource "aws_instance" "custom_ec2" {
  count = 2
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.aws_ec2_size
  subnet_id     = aws_subnet.custom_subnets[count.index].id
  key_name         = var.key
  security_groups = [ count.index == 0 ? aws_security_group.custom_sg.id : aws_security_group.private_sg.id ]
  tags = {
    Name = "custom_ec2-${count.index == 0 ? "bastion" : "private"}"
  }

  provisioner "remote-exec" {
    inline = [
      count.index == 0 ? "sudo apt update -y && sudo apt install -y nginx" : "sudo apt update -y && sudo apt --fix-broken install -y && sudo apt install -y apache2",
      "sudo systemctl start ${count.index == 0 ? "nginx" : "apache2"}",
      "sudo systemctl enable ${count.index == 0 ? "nginx" : "apache2"}"
    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/ivolve/Terraform/Project1_Key.pem")
      host = count.index == 0 ? self.public_ip : self.private_ip
      bastion_host = count.index == 1 ? aws_instance.custom_ec2[0].public_ip : null

    }
  }

}
```
---

### 6.Define the Output Block for Ec2 IP

```
output "ec2_ips" {
  value = {
    for instance in aws_instance.custom_ec2 :
    instance.id => {
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
    }
  }
  description = "Public and Private IPs of EC2 instances"
}
```

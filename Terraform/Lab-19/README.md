# Lab 19: Remote Backend and LifeCycle Rules  

## Objective  

1. Implement the provided architecture diagram using Terraform.  
2. Store the Terraform state file in a remote backend.  
3. Configure a `create_before_destroy` lifecycle rule for an EC2 instance and verify its behavior.  

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

### 2. Implement the Architecture

1. **Define network Resources in main.tf**:

```
#Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC"
  }
}

#Create Internet Gateway and attach it to VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "IGW"
  }
}

#Create a public Subnet 

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_block
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}

#Create a Route Table and add public route

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

#Associate public subnet with public route table

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
```
---
2. **Define Compute Resources in main.tf**:

```
#Create a Security Group for Ec2 
resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id
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

#Create an Ec2
resource "aws_instance" "ec2" {
  ami = data.aws_ami.Amazon-linux-ami.id
  instance_type = var.aws_ec2_size
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  key_name = var.key_name
  tags = {
    Name = "Ec2-new"
  }
  
  lifecycle {
    create_before_destroy = true
  }

}

```
---

3. **Configure SNS in main.tf**:

```
# Create an SNS topic
resource "aws_sns_topic" "cpu_alert_topic" {
  name = "cpu_alert_topic"
}


# Create an SNS subscription (email)
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cpu_alert_topic.arn
  protocol  = "email"
  endpoint  = var.my_email
}
```
---

4. **Configure a Clouwatch Agent on Ec2**

```
# CloudWatch Metric Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name                = "HighCPUUsage"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 300
  statistic                 = "Average"
  threshold                 = var.threshold_cpu 
  alarm_description         = "This alarm triggers when CPU usage exceeds 70% for the instance."
  alarm_actions             = [aws_sns_topic.cpu_alert_topic.arn]
  insufficient_data_actions = []
  ok_actions                = [aws_sns_topic.cpu_alert_topic.arn]

  # Attach to a specific EC2 instance
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}
```

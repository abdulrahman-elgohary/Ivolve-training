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




variable "aws_region" {
    type = string
}

variable "availability_zone" {
    type = string
}
variable "vpc_cidr_block" {
    type = string
}

variable "public_subnet_cidr_block" {
    type = string
}

data "aws_ami" "Amazon-linux-ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

variable "aws_ec2_size" {
  type = string
}

variable "key_name" {
    type = string
}

variable "threshold_cpu" {
    type = number
}

variable "my_email" {
    type = string
}


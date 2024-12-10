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


variable "public_subnet_id" {
  type = list(string)
}

variable "sg_proxy_tr" {
  type = string
}

variable "private_subnet_id" {
  type = list(string)
}
  
variable "sg_http_tr" {
  type = string
}

variable "in-lb-dns-name" {
  type = string
}

variable "in-lb-arn" {
  type = string
}

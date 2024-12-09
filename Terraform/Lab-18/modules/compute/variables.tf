
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

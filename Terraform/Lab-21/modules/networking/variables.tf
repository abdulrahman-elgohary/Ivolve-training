variable "aws_region"  {
    type = string
}

#Network Variables
variable "aws_vpc_cidr" {
    type = string
}
variable "availability_zones" {
  type = list(string)
}

#public subnets
variable "aws_public_subnet_cidrs" {
    type = list(string)
}
#Private Subnets 
variable "aws_private_subnet_cidrs" {
    type = list(string)
}


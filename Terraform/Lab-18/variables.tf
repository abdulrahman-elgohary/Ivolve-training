variable "vpc_cidr" {
    type = string
}

variable "public_subnet_cidr" {
    type = list(string)
}

variable "availability_zone" {
    type = string
}

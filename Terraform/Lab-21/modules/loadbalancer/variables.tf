variable "vpc_id" {
  type = string 
}

variable "sg-lb-tr" {
 type = string  
}

variable "public_subnets" {
  type = list(string)
}

variable "proxy-instances-id" {
    type = list(string)
}

variable "sg-in-lb-tr" {
  type = string
}

variable "private_subnets" {
  type = list(string) 
}

variable "http-instances-id" {
  type = list(string) 
}

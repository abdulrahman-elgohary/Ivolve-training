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


#Create a Security Group for the Ec2
resource "aws_security_group" "sg_nginx_tr" {
  name        = "sg_http_tr"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    description = "Allow ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_http_tr"
  }
}

#Create an Ec2 in each Subnet

module "ec2_subnet_1" {
  source = "./modules/compute"
  subnet_id = aws_subnet.public_subnet[0].id
}

module "ec2_subnet_2" {
  source = "./modules/compute"
  subnet_id = aws_subnet.public_subnet[1].id
}

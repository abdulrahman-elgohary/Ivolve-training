#Create a Vpc
resource "aws_vpc" "vpc-tr" {
  cidr_block = var.aws_vpc_cidr
  tags = {
    Name = "vpc-tr"
  }
}
#Create  public subnets
resource "aws_subnet" "public-subnets" {
  count = length(var.aws_public_subnet_cidrs)
  vpc_id     = aws_vpc.vpc-tr.id
  cidr_block = var.aws_public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-tr-${count.index + 1}"
  }
}

#Create  private subnets
resource "aws_subnet" "private-subnets" {
  count = length(var.aws_private_subnet_cidrs)
  vpc_id     = aws_vpc.vpc-tr.id
  cidr_block = var.aws_private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "private-subnet-tr-${count.index + 1}"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "igw-tr" {
  vpc_id = aws_vpc.vpc-tr.id
  tags = {
    Name = "igw-tr"
  }
}

#Create 2 EIP for NAT Gateway
resource "aws_eip" "eip-tr" {
  count = length(var.aws_private_subnet_cidrs)
}

#Create 2 NAT Gateways
resource "aws_nat_gateway" "nat-gw-tr" {
  count = length(var.aws_private_subnet_cidrs)
  allocation_id = aws_eip.eip-tr[count.index].id
  subnet_id     = aws_subnet.public-subnets[count.index].id
  depends_on = [aws_internet_gateway.igw-tr]
  tags = {
    Name = "nat-gw-tr-${count.index + 1}"
  }
}

#Create route table for public subnets
resource "aws_route_table" "route-t-public-subnet-tr" {
  vpc_id = aws_vpc.vpc-tr.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tr.id
  }
  tags = {
    Name = "route-t-public-subnet-tr"
  }
}

## Associate the public subnets to route table 
resource "aws_route_table_association" "associate-public-subnets" {
  count = length(aws_subnet.public-subnets)
  subnet_id      = aws_subnet.public-subnets[count.index].id
  route_table_id = aws_route_table.route-t-public-subnet-tr.id
}


#Create two route tables for private subnets
resource "aws_route_table" "route-t-private-subnet-tr" {
  count = length(aws_nat_gateway.nat-gw-tr)
  vpc_id = aws_vpc.vpc-tr.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw-tr[count.index].id
  }
  tags = {
    Name = "private-subnet-tr-${count.index + 1}"
  }
}

## Associate the first private subnet to route table

resource "aws_route_table_association" "associate-private-subnets" {
  count = length(aws_subnet.private-subnets)
  subnet_id      = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.route-t-private-subnet-tr[count.index].id
}

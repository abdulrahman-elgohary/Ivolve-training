#Create a VPC 
resource "aws_vpc" "custom_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true 
  enable_dns_hostnames = true

  tags = {
    Name = "custom_vpc"
  }
 

}

#Create a Internet Gateway
resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id

  tags = {
    Name = "custom_igw"
  }
}

#Create a Elastic IP Address
resource "aws_eip" "custom_eip" {


  tags = {
    Name = "custom_eip"
  }
}

#Create a Nat Gateway 
resource "aws_nat_gateway" "custom_nat" {
  allocation_id = aws_eip.custom_eip.id
  subnet_id     = aws_subnet.custom_subnets[0].id

  tags = {
    Name = "custom_nat"
  }
}


#Create Public Subnet

resource "aws_subnet" "custom_subnets" {
  count = 2
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_value[count.index]
  tags = {
    Name = "custom_${var.subnet_name[count.index]}_subnet"
  }
}

#Create a Route Table
resource "aws_route_table" "custom_rt" {
  count = 2
  vpc_id = aws_vpc.custom_vpc.id

  dynamic "route" {
    for_each = count.index == 0  ? [ { cidr_block = "0.0.0.0/0", gateway_id = aws_internet_gateway.custom_igw.id } ] : [ { cidr_block = "0.0.0.0/0", nat_gateway_id = aws_nat_gateway.custom_nat.id } ]
    content {
      cidr_block    = route.value.cidr_block
      gateway_id    = lookup(route.value, "gateway_id", null)
      nat_gateway_id = lookup(route.value, "nat_gateway_id", null)
    }
  }

  tags = {
    Name = count.index == 0 ? "public_rt" : "private_rt"
  }
}

#Associate Public Subnet to the route table 
resource "aws_route_table_association" "public_subnet_association" {
  count = 2
  subnet_id      = aws_subnet.custom_subnets[count.index].id
  route_table_id = aws_route_table.custom_rt[count.index].id
}

#Create a Security Group for Public Ec2
resource "aws_security_group" "custom_sg" {
  name        = "custom_sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
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
    Name = "custom_sg"
  }
}

#Create a Security Group for Private Ec2
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.custom_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_sg"
  }
}
#Create Ec2 
resource "aws_instance" "custom_ec2" {
  count = 2
  ami           = data.aws_ami.ubuntu_ami.id
  instance_type = var.aws_ec2_size
  subnet_id     = aws_subnet.custom_subnets[count.index].id
  key_name         = var.key
  security_groups = [ count.index == 0 ? aws_security_group.custom_sg.id : aws_security_group.private_sg.id ]
  tags = {
    Name = "custom_ec2-${count.index == 0 ? "bastion" : "private"}"
  }

  provisioner "remote-exec" {
    inline = [
      count.index == 0 ? "sudo apt update -y && sudo apt install -y nginx" : "sudo apt update -y && sudo apt --fix-broken install -y && sudo apt install -y apache2",
      "sudo systemctl start ${count.index == 0 ? "nginx" : "apache2"}",
      "sudo systemctl enable ${count.index == 0 ? "nginx" : "apache2"}"
    ]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/ivolve/Terraform/Project1_Key.pem")
      host = count.index == 0 ? self.public_ip : self.private_ip
      bastion_host = count.index == 1 ? aws_instance.custom_ec2[0].public_ip : null

    }
  }

}

output "ec2_ips" {
  value = {
    for instance in aws_instance.custom_ec2 :
    instance.id => {
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
    }
  }
  description = "Public and Private IPs of EC2 instances"
}

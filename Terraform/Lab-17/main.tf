
data "aws_vpc" "by_tag" {
  tags = {
    Name = "ivolve-vpc"
  }
}

#Create Internet Gateway 
resource "aws_internet_gateway" "ivolve-igw" {
  vpc_id = data.aws_vpc.by_tag.id
  tags = {
    Name = "ivolve-igw"
  }
}

#Create a Route Table 
resource "aws_route_table" "ivolve-rt" {
  vpc_id = data.aws_vpc.by_tag.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ivolve-igw.id
  }
  tags = {
    Name = "ivolve-rt"
  }
}

#Associate First Public SUbnet to Route Table
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.Public-1.id
  route_table_id = aws_route_table.ivolve-rt.id
}
#Create the first Public Subnet
resource "aws_subnet" "Public-1" {
  vpc_id     = data.aws_vpc.by_tag.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-1"
  }
}

#Create a Private SUbnet
resource "aws_subnet" "Private-1" {
  vpc_id     = data.aws_vpc.by_tag.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private-1"
  }
}
#Create a Security Group for Ec2 
resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.by_tag.id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
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
    Name = "ec2-sg"
  }
}

#Create the First Ec2
resource "aws_instance" "ec2-1" {
  ami           = "ami-0e2c8caa4b6378d8c"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.Public-1.id
  security_groups = [aws_security_group.ec2-sg.id]
  key_name= "Project1_Key"
  tags = {
    Name = "ec2-1"
  }
  
  provisioner "local-exec" {
   command = "echo ${self.public_ip} > ec2-ip.txt"
  }

}


#Create a security group for RDS 
resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.by_tag.id
  
  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups =  [aws_security_group.ec2-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-sg"
  }
}

#Create RDS Database as a second Tier
resource "aws_db_subnet_group" "rds-subnet" {
  name       = "rds-subnet"
  subnet_ids = [aws_subnet.Private-1.id , aws_subnet.Public-1.id]
  tags = {
    Name = "rds-subnet"
  }
}

# Create the RDS Database
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20                       # Storage size in GB
  engine               = "mysql"                  # Replace with your desired engine (e.g., "postgres", 
  engine_version       = "8.0.39"                 # Specific version of the engine
  instance_class       = "db.t3.micro"            # RDS instance type
  username             = "admin"                  # Master username
  password             = "Password123" # Master password
  parameter_group_name = "default.mysql8.0"       # Replace with your engine's default parameter group
  publicly_accessible  = true                     # Set false for private instances
  skip_final_snapshot  = true                     # Avoid snapshot on deletion for testing
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet.name
}


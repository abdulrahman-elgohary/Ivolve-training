#Security Group for Internet Load Balancer 
resource "aws_security_group" "lb-sg-tr" {
  name        = "lb-sg-tr"
  description = "http and https access to lb"
  vpc_id      = var.vpc_id
  tags = {
    Name = "lb-sg-tr"
  }
  ingress {   #Allow Http
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

}

#Create a Security Group for the proxy instances
resource "aws_security_group" "proxy-sg-tr" {
  name        = "proxy-sg-tr"
  description = "SSH access to proxy"
  vpc_id      = var.vpc_id
  tags = {
    Name = "proxy-sg-tr"
  }
  ingress { #Allow SSH
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { ## Allow http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.lb-sg-tr.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create the security group for internal load balancer
resource "aws_security_group" "internal-lb-sg-tr" {
  name        = "internal-lb-sg-tr"
  description = "http and https access to internal lb"
  vpc_id      = var.vpc_id
  tags = {
    Name = "internal-lb-sg-tr"
  }
  ingress {   #Allow Http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.proxy-sg-tr.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Create Securiry group for the http instance
resource "aws_security_group" "http-sg-tr" {
  name        = "http-sg-tr"
  description = "http access to instances"
  vpc_id      = var.vpc_id
  tags = {
    Name = "http-sg-tr"
  }
  ingress {   #Allow Http
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups =  [aws_security_group.internal-lb-sg-tr.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
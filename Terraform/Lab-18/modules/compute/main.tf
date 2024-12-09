

resource "aws_instance" "Nginx-Instance" { 
  ami           = data.aws_ami.Amazon-linux-ami.id
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = module.sg_ec2
  key_name = "Test"
  user_data =  <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
  EOF
  tags = {
    Name = "Nginx-Ec2"
  }

}


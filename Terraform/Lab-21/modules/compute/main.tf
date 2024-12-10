#Create  two nginx Ec2 Instances
resource "aws_instance" "proxy-tr-instances" {
  count = 2
  ami           = data.aws_ami.Amazon-linux-ami.id
  instance_type = var.aws_ec2_size
  subnet_id = var.public_subnet_id[count.index]
  vpc_security_group_ids = [var.sg_proxy_tr]
  key_name = "Project1_Key"
  tags = {
    Name = "proxy-tr-${count.index + 1}"
  }
  #Install Nginx as a proxy server
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install nginx1 -y",
      "sudo echo 'server {listen 80; location / { proxy_pass http://${var.in-lb-dns-name}; } }' | sudo tee /etc/nginx/conf.d/proxy.conf",
      "sudo rm /usr/share/nginx/html/index.html",
      "sudo touch /usr/share/nginx/html/index.html",
      "sudo echo 'Hello from Proxy1' | sudo tee /usr/share/nginx/html/index.html",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      "sleep 5", 
      "sudo nginx -t",
      "sudo systemctl restart nginx"
    ]
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/ivolve/Terraform/Project1_Key.pem")
      host = self.public_ip
      timeout = "5m"
    }

   
  }
}


# Create two http  Ec2 Instances

resource "aws_instance" "http-instances" { 
  count = 2 
  ami           = data.aws_ami.Amazon-linux-ami.id
  instance_type = var.aws_ec2_size
  subnet_id = var.private_subnet_id[count.index]
  vpc_security_group_ids = [var.sg_http_tr]
  key_name = "testkey"
  user_data =  <<EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install -y httpd
  sudo systemctl start httpd
  sudo systemctl enable httpd
  echo '<html><body><h1>Hello from Server ${count.index + 1 } </h1></body></html>' | sudo tee /var/www/html/index.html
  sudo systemctl restart httpd
  EOF
  tags = {
    Name = "http-tr-${count.index + 1 }"
  }

}


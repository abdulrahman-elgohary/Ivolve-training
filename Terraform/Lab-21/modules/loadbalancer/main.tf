#Create the internet load balancer
resource "aws_lb" "lb-tr" {
  name               = "lb-tr"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg-lb-tr]
  subnets            = var.public_subnets 
  tags = {
    Name = "lb-tr"
  }
}

#Create the target group for the internet load balancer
resource "aws_lb_target_group" "lb-tr-tg" {
  name     = "lb-tr-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled  = true
    healthy_threshold = 2
    interval = 30
    path     = "/"
    port     = "80"
    protocol = "HTTP"
    timeout  = 5
    unhealthy_threshold = 2
  }
  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 5  # Sets stickiness duration to 60 seconds
  }
  tags = {
    Name = "lb-tr-tg"
  }
}

#Create the listener on port 80 for the load balancer
resource "aws_lb_listener" "lb-tr-listener" {
  load_balancer_arn = aws_lb.lb-tr.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tr-tg.arn
  }
}


#Register proxy instances with target group
resource "aws_lb_target_group_attachment" "lb-tr-tg-attachment-1" {
  count = 2
  target_group_arn = aws_lb_target_group.lb-tr-tg.arn
  target_id        = var.proxy-instances-id[count.index]
  port             = 80
}


#Create the internal load balancer
resource "aws_lb" "internal-lb-tr" {
  name               = "in-lb-tr"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.sg-in-lb-tr]
  subnets            = var.private_subnets
  tags = {
    Name = "in-lb-tr"
  }
}

#Create the load balancer listener on port 80 for the internal load balancer
resource "aws_lb_listener" "internal-lb-tr-listener" {
  load_balancer_arn = aws_lb.internal-lb-tr.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal-lb-tr-tg.arn
  }
}

#Create the target group for the internal load balancer
resource "aws_lb_target_group" "internal-lb-tr-tg" {
  name     = "internal-lb-tr-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled  = true
    healthy_threshold = 3
    interval = 30
    path     = "/"
    port     = "80"
    protocol = "HTTP"
    timeout  = 5
    unhealthy_threshold = 4
  }
  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 5 # Sets stickiness duration to 60 seconds
  }
  tags = {
    Name = "internal-lb-tr-tg"
  }
}

# #Register first instance with internal target group
resource "aws_lb_target_group_attachment" "internal-lb-tr-tg-attachment-1" {
  count = 2 
  target_group_arn = aws_lb_target_group.internal-lb-tr-tg.arn
  target_id        = var.http-instances-id[count.index]
  port             = 80
}




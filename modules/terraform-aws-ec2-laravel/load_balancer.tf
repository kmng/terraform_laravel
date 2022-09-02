resource "aws_lb" "web_servers" {
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.web.id]
  subnets                    = var.public_subnet_ids
  enable_http2               = false
  enable_deletion_protection = false

  tags = {
    Terraform = "true"
    Name      = "load-balancer-${var.stack_name}"
  }
}


resource "aws_lb_target_group" "web_servers" {

  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    Terraform = "true"
    Name      = "target-group-${var.stack_name}"
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_servers.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_servers.arn
  }

  tags = {
    Terraform = "true"
    Name      = "lb-listener-${var.stack_name}"
  }
}


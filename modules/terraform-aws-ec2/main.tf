
data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


resource "aws_launch_template" "web-server" {
  name_prefix   = "web-server"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "terraform"

  user_data = var.user_data

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.web.id]
    delete_on_termination       = true
  }
  tags = {
    Terraform = "true"
    Name      = "launch-template-${var.stack_name}"
  }
}


resource "aws_autoscaling_group" "web-servers" {
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity    = 2
  max_size            = 4
  min_size            = 1

  tag {

    key                 = "Name"
    value               = "autoscaling-group-${var.stack_name}"
    propagate_at_launch = true
  }


  launch_template {
    id = aws_launch_template.web-server.id

  }
}

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





resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.web-servers.id
  alb_target_group_arn   = aws_lb_target_group.web_servers.arn
}


resource "aws_security_group" "web" {
  description = "Allow standard http and https ports inbound and everything outbound"
  vpc_id      = var.vpc_id

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
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name      = "firewall-${var.stack_name}"
    Terraform = "true"
  }
}
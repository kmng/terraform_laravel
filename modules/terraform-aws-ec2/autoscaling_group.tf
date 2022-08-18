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
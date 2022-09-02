data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}







resource "aws_autoscaling_attachment" "web" {
  autoscaling_group_name = aws_autoscaling_group.web-servers.id
  lb_target_group_arn    = aws_lb_target_group.web_servers.arn
}




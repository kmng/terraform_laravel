resource "aws_launch_template" "web-server" {
  name_prefix   = "web-server"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "terraform"

  user_data = var.user_data



  iam_instance_profile {
    name = aws_iam_instance_profile.session-manager-instance-profile.name
  }

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

resource "aws_iam_role" "session-manager-role" {
  name = "session-manager-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF

  tags = {
    Terraform = "true"
    Name      = "session-manager-role-${var.stack_name}"
  }
}

resource "aws_iam_role_policy" "session-manager-policy" {
  name = "session-manager-policy"
  role = aws_iam_role.session-manager-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeAssociation",
                "ssm:GetDeployablePatchSnapshotForInstance",
                "ssm:GetDocument",
                "ssm:DescribeDocument",
                "ssm:GetManifest",
                "ssm:GetParameter",
                "ssm:GetParameters",
                "ssm:ListAssociations",
                "ssm:ListInstanceAssociations",
                "ssm:PutInventory",
                "ssm:PutComplianceItems",
                "ssm:PutConfigurePackageResult",
                "ssm:UpdateAssociationStatus",
                "ssm:UpdateInstanceAssociationStatus",
                "ssm:UpdateInstanceInformation"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2messages:AcknowledgeMessage",
                "ec2messages:DeleteMessage",
                "ec2messages:FailMessage",
                "ec2messages:GetEndpoint",
                "ec2messages:GetMessages",
                "ec2messages:SendReply"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_instance_profile" "session-manager-instance-profile" {
  name = "session-manager"
  role = aws_iam_role.session-manager-role.name

  tags = {
    Terraform = "true"
    Name      = "session-manager-instance-profile-${var.stack_name}"
  }
}

resource "aws_instance" "bastion_host" {
  ami             = data.aws_ami.amazon-2.id
  instance_type   = "t2.micro"
  key_name        = "terraform"
  security_groups = [aws_security_group.web.id]
  subnet_id       = element(var.public_subnet_ids, 0)

  user_data = <<EOF
#!/bin/sh
yum install -y mysql
EOF

  provisioner "file" {
    source      = "terraform.pem"
    destination = "terraform.pem"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.private_key
      host        = self.public_dns
    }
  }
  tags = {
    Name      = "bastion-host-${var.stack_name}"
    Terraform = "true"
  }
}
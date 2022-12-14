
resource "aws_instance" "bastion_host" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.micro"
  key_name        = "terraform"
  security_groups = [aws_security_group.web.id]
  subnet_id       = element(var.public_subnet_ids, 0)

  provisioner "file" {
    source      = "terraform.pem"
    destination = "terraform.pem"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.private_key
      host        = self.public_dns
    }
  }
  tags = {
    Name      = "bastion-host-${var.stack_name}"
    Terraform = "true"
  }
}
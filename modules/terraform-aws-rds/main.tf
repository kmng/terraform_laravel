#create aws rds subnet groups
resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "mydbsg"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "database_subnet_group-${var.stack_name}"
  }
}

#create aws mysql rds instance
resource "aws_db_instance" "database_instance" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  port                   = 3306
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  db_name                = var.db_database
  identifier             = "mysqldb"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  tags = {
    Name = "database_instance-${var.stack_name}"
  }
}
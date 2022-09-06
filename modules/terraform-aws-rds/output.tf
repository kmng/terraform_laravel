output "db_host" {
  value = aws_db_instance.database_instance.address
}


output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}

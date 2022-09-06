output "vpc_id" {
  value = module.vpc.vpc_id
}


output "alb_url" {
  value = module.ec2-laravel.alb_url
}

output "db_host" {
  value = module.rds-laravel.db_host
}


output "db_username" {
  value = var.db_username
}


output "db_password" {
  value     = module.rds-laravel.db_password
  sensitive = true
}

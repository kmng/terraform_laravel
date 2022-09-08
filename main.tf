

module "vpc" {
  source               = "./modules/terraform-aws-vpc"
  stack_name           = var.stack_name
  public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets_cidr = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones   = ["us-west-2a", "us-west-2b", "us-west-2c"]

}


# module "ec2" {
#   source             = "./modules/terraform-aws-ec2"
#   stack_name         = var.stack_name
#   private_subnet_ids = module.vpc.private_subnet_ids
#   public_subnet_ids  = module.vpc.public_subnet_ids

#   user_data   = base64encode(file("install.sh"))
#   private_key = file("terraform.pem")

#   vpc_id = module.vpc.vpc_id


# }


module "ec2-laravel" {
  source             = "./modules/terraform-aws-ec2-laravel"
  stack_name         = var.stack_name
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  user_data = base64encode(templatefile("install-laravel.sh", {

    db_host     = module.rds-laravel.db_host
    db_database = var.db_database
    db_username = var.db_username
    db_password = module.rds-laravel.db_password
    redis_host  = module.rds-laravel.redis_host

    }
  ))
  private_key = file("terraform.pem")

  vpc_id = module.vpc.vpc_id


}


module "rds-laravel" {
  source             = "./modules/terraform-aws-rds"
  stack_name         = var.stack_name
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids

  db_database = var.db_database
  db_username = var.db_username


  vpc_id = module.vpc.vpc_id


}



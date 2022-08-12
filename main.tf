variable "stack_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}



module "vpc" {
  source     = "./modules/terraform-aws-vpc"
  vpc_stack_name = var.stack_name
  vpc_aws_region = var.aws_region
  vpc_aws_profile = var.aws_profile

}

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_id" {
  value = module.vpc.vpc_id
}


output "alb_url" {
  value = module.ec2.alb_url
}

variable "stack_name" {
  type        = string
  description = "Name of the Stack"
}


variable "private_subnet_ids" {
  type        = list(any)
  description = "private subnet ID"
}




variable "public_subnet_ids" {
  type        = list(any)
  description = "public subnet ID"
}



variable "vpc_id" {
  type        = string
  description = "VPC ID"
}


variable "db_database" {
  type = string
}


variable "db_username" {
  type = string
}


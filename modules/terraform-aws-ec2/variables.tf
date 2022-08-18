
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




variable "user_data" {
  type        = string
  description = "User Data for EC2"
}


variable "private_key" {
  type        = string
  description = "Private Key"
}

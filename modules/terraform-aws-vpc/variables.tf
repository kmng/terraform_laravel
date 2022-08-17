
variable "stack_name" {
  type        = string
  description = "Name of the Stack"
}


variable "public_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "The CIDR block for the private subnet"
}

variable "availability_zones" {
  type        = list(any)
  description = "The az that the resources will be launched"
}

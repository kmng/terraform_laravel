

resource "aws_elasticache_subnet_group" "redis" {
  name       = "eleasticache-subnet-group-${var.stack_name}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name      = "redis-subnet-group-${var.stack_name}"
    Terraform = "true"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "elasticache-redis-${var.stack_name}"
  engine               = "redis"
  engine_version       = "6.2"
  maintenance_window   = "sun:05:00-sun:06:00"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = "1"
  parameter_group_name = "default.redis6.x"
  port                 = "6379"
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redis.id]

  tags = {
    Name      = "redis-cluster-${var.stack_name}"
    Terraform = "true"
  }
}
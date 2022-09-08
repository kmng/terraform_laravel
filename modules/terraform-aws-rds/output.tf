output "db_host" {
  value = aws_db_instance.database_instance.address
}


output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}


output "redis_host" {
  value = aws_elasticache_cluster.redis.cache_nodes.0.address
}

output "redis_port" {
  value = aws_elasticache_cluster.redis.cache_nodes.0.port
}

output "redis_endpoint" {
  value = "${aws_elasticache_cluster.redis.cache_nodes[0].address}:${aws_elasticache_cluster.redis.cache_nodes[0].port}"
}
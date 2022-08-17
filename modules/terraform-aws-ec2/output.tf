output "alb_url" {
  value = "http://${aws_lb.web_servers.dns_name}"
}


output "load_balancer_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.drazex_application_lb.arn
}

output "target_group_arn" {
  description = "ARN of the Target Group"
  value       = aws_lb_target_group.drazex_target_group.arn
}

output "load_balancer_security_group_id" {
  description = "ID of the Load Balancer Security Group"
  value       = aws_security_group.drazex_load_balancer_security_group.id
}

output "load_balancer_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.drazex_application_lb.dns_name
}

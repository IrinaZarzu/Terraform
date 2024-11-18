output "alb_public_dns" {
  value       = "https://${aws_lb.alb-tier1.dns_name}"
  description = "DNS for the application load balancer"
}

output "db_dbtier3_id" {
  value       = aws_db_instance.primary-dbtier3.id
  description = "RDS MySQL instance id"
}

output "cloudfront_domain_name_for_origin_group" {
  value = aws_cloudfront_distribution.s3_alb_distribution.domain_name
}


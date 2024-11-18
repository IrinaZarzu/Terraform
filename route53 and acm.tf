/*
Code to create and validate ACM certificate and create Route53 hosted zone
# Since I have already created the ACM and the hosted zone in the AWS console, 
# I will reference them as data blocks, below


# Create a hosted zone for DNS management

resource "aws_route53_zone" "primary" {
  name = var.domain_name
  force_destroy = true
}

# Declare ACM certificate

 resource "aws_acm_certificate" "thread" {
 domain_name       = var.domain_name
 validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS records for ACM validation
resource "aws_route53_record" "thread" {
  for_each = { for dvo in aws_acm_certificate.thread.domain_validation_options : dvo.domain_name => dvo }

  name    = each.value.resource_record_name
  records = [each.value.resource_record_value]
  ttl     = 60
  type    = each.value.resource_record_type
  zone_id = aws_route53_zone.primary.zone_id
  
}

resource "aws_acm_certificate_validation" "thread" {
  certificate_arn         = aws_acm_certificate.thread.arn
  validation_record_fqdns = [for record in aws_route53_record.thread : record.fqdn]
}

*/
######################################################


# Add data block for referencing the existing ACM certificate

data "aws_acm_certificate" "thread_cert" {
  domain      = "threadcraft.link"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

# Reference an existing Route 53 hosted zone by its domain name 

data "aws_route53_zone" "primary" {
  name         = var.hosted_zone_name      
  private_zone = false             
}


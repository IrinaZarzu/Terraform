# Define Origin Access Control

resource "aws_cloudfront_origin_access_control" "thread_oac" {
  name                              = "${var.bucket_name_oac}-oac"
  description                       = "OAC for S3 access"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


  /* !!!!!!!!!!!!!!!  To be used when there is only the S3 distribution
# Define CloudFront distribution

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.thread-bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.thread_oac.id
    origin_id                = "myS3Origin"
  }

restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Distribution for threadcraft.link"
  default_root_object = "diagram.html.svg"


  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 259200
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.thread_cert.arn
    ssl_support_method       = "sni-only"                     
    minimum_protocol_version = "TLSv1.2_2019"
  }

}
*/

######################################################################

# Define CloudFront distribution

resource "aws_cloudfront_distribution" "s3_alb_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Distribution for threadcraft.link"
  default_root_object = "diagram.html.svg"
  aliases             = [var.domain_name, var.domain_name_alborigin]
  web_acl_id          = aws_wafv2_web_acl.cloudfront_web_acl.arn

# Set the default origin for S3
  origin {
    domain_name              = aws_s3_bucket.thread-bucket-oac.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.thread_oac.id
    origin_id                = "myS3Origin"
  }

# Set the origin for ALB
 origin {
    domain_name              = aws_lb.alb-tier1.dns_name
    origin_id                = "myALBorigin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1"]
    }

    custom_header {
      name     = "verify-x-origin"
      value    = var.origin_verify_secret
    }
  }

 # Default cache behavior - routes to S3 by default - for static content

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 259200
  }
  
  # Cache behavior for index.html - routes to ALB

  ordered_cache_behavior {
    path_pattern     = "/index.html"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myALBorigin"

    forwarded_values {
      query_string = true
      headers      = ["*"] 

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 86400
  }

# Cache behaviour for ALB - for dynamic content

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id = "myALBorigin"
    path_pattern     = "/app/*"

    forwarded_values {
      query_string = true
      headers      = ["*"] 

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 86400 
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.thread_cert.arn
    ssl_support_method       = "sni-only"                     
    minimum_protocol_version = "TLSv1.2_2019"
  }

      restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}


# Create an Alias record to point to the CloudFront distribution

 resource "aws_route53_record" "cloudfront_alias" {
   zone_id = data.aws_route53_zone.primary.zone_id
   name    = var.domain_name
   type    = "A"

   alias {
     name                   = aws_cloudfront_distribution.s3_alb_distribution.domain_name
     zone_id                = aws_cloudfront_distribution.s3_alb_distribution.hosted_zone_id
     evaluate_target_health = false
  }

 }

 # Create an Alias record to point to ALB origin

 resource "aws_route53_record" "alb_alias" {
   zone_id = data.aws_route53_zone.primary.zone_id
   name    = var.domain_name_alborigin
   type    = "A"

   alias {
     name                   = aws_cloudfront_distribution.s3_alb_distribution.domain_name
     zone_id                = aws_cloudfront_distribution.s3_alb_distribution.hosted_zone_id
     evaluate_target_health = false
  }

 }

 # Create an Alias record to point to ALB 
  resource "aws_route53_record" "albtier1_alias" {
   zone_id = data.aws_route53_zone.primary.zone_id
   name    = var.domain_name_alb
   type    = "A"

   alias {
     name                   = aws_lb.alb-tier1.dns_name
     zone_id                = aws_lb.alb-tier1.zone_id
     evaluate_target_health = false
  }
  }

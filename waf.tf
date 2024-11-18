# Create WAF Web ACL for CloudFront


resource "aws_wafv2_web_acl" "cloudfront_web_acl" {
  name        = "cloudfront-web-acl"
  description = "CF Web ACL to validate the X-Origin verify header"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

# Create WAF rule for CloudFront to verify X-Origin header

  rule {
    name     = "verifyxorigin"
    priority = 1

    action {
      block {}  # Block if header does not match
    }

    statement {
      byte_match_statement {
        field_to_match {
          single_header {
            name = "verify-x-origin"
          }
        }
        positional_constraint = "EXACTLY"
        search_string         = var.origin_verify_secret
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "verifyxorigin"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "CloudFrontWebACL"
    sampled_requests_enabled   = true
  }
}

# Create WAF Web ACL for ALB

resource "aws_wafv2_web_acl" "alb_web_acl" {
  name        = "alb-web-acl"
  description = "ALB web ACL"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet" 
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CRSRule"
      sampled_requests_enabled   = true
    }
  }


    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "ALBwebACL"
      sampled_requests_enabled   = true
    }

}

# Link the ALB web acl to the ALB tier 1 resource creating an association 
# in the loadbalancers.tf file


# To link the CloudFront Web ACL to the Cloudfront distribution, 
# go to CloudFront.tf, set the web_acl_id parameter under Cloudfront distribution

# aws_lb tier 1 

resource "aws_lb" "alb-tier1" {
  name               = "alb-webservers"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-tier1.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  enable_deletion_protection = false # Terraform will be able to delete the ALB

  tags = local.common_tags
}

# Create the association between WAF alb web acl and ALB first tier

resource "aws_wafv2_web_acl_association" "alb_association" {
 resource_arn = aws_lb.alb-tier1.arn
 web_acl_arn  = aws_wafv2_web_acl.alb_web_acl.arn
 }

# target group ALB

resource "aws_lb_target_group" "first-tiertg" {
  name     = "first-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_site_vpc.id

  tags = local.common_tags

  health_check {
    protocol            = "HTTP"
    path                = "/index.html"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2

  }
}

# aws_lb_listener

resource "aws_lb_listener" "first-tierlsn" {
  load_balancer_arn = aws_lb.alb-tier1.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.thread_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.first-tiertg.arn
  }

  tags = local.common_tags
}


##########################################################################

# aws_lb tier 2

resource "aws_lb" "alb-tier2" {
  name               = "alb-appservers"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-tier2.id]
  subnets            = [aws_subnet.private_subnet3.id, aws_subnet.private_subnet4.id]

  enable_deletion_protection = false # Terraform will be able to delete the ALB

  tags = local.common_tags
}

# target group ALB

resource "aws_lb_target_group" "second-tiertg" {
  name     = "second-tier-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_site_vpc.id

health_check {
    protocol            = "HTTP"
    path                = "/index.html"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2

  }
  
  tags = local.common_tags

}


# aws_lb_listener

resource "aws_lb_listener" "second-tierlsn" {
  load_balancer_arn = aws_lb.alb-tier2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.second-tiertg.arn
  }

  tags = local.common_tags
}

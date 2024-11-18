# VPC endpoint

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.my_site_vpc.id
  service_name      = "com.amazonaws.${var.aws_regions}.s3"
  vpc_endpoint_type = "Gateway"

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow-access-to-specific-bucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
         "s3:ListBucket",
         "s3:GetObject",
         "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.thread-bucket.arn}",
        "${aws_s3_bucket.thread-bucket.arn}/*"
      ]
    }
  ]
}
EOF

  tags = local.common_tags
}
# Associate route table with VPC endpoint

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.three-tier-rt.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

# Create S3 bucket for VPC

resource "aws_s3_bucket" "thread-bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = local.common_tags

}

# Enable S3 bucket versioning

resource "aws_s3_bucket_versioning" "thread-bucket" {
  bucket = aws_s3_bucket.thread-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object1" {
  bucket       = aws_s3_bucket.thread-bucket.id
  key          = "index.html"
  content_type = "text/html"
  source       = "C:/Users/Irina/Downloads/Getting-Started-Terraform-main/currently 3 tier/files/index.html"

}

data "aws_iam_policy_document" "allow_vpc" {

  statement {
    sid       = "AllowVPCAccess"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.thread-bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpc"
      values   = [aws_vpc.my_site_vpc.id]
    }
  }

  # Statement to allow VPC access to list the bucket
  statement {
    sid       = "AllowListBucketForVPCAccess"
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.thread-bucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpc"
      values   = [aws_vpc.my_site_vpc.id]
    }
  }
}

# Attach bucket policy to S3
resource "aws_s3_bucket_policy" "thread-bucket-pol" {
  bucket = aws_s3_bucket.thread-bucket.id
  policy = data.aws_iam_policy_document.allow_vpc.json

}

###################################################################

#S3 bucket for CloudFront

resource "aws_s3_bucket" "thread-bucket-oac" {
  bucket        = var.bucket_name_oac
  force_destroy = true

  tags = local.common_tags

}

# Enable S3 bucket versioning

resource "aws_s3_bucket_versioning" "thread-bucket-oac" {
  bucket = aws_s3_bucket.thread-bucket-oac.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Upload the .svg file to the bucket

resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.thread-bucket-oac.id
  key          = "diagram.html.svg"
  content_type = "image/svg+xml"
  source       = "C:/Users/Irina/Downloads/Getting-Started-Terraform-main/currently 3 tier/files/diagram.html.svg"

}

data "aws_iam_policy_document" "allow_cloudfront" {
  statement {
    actions = ["s3:GetObject"]

    resources = ["${aws_s3_bucket.thread-bucket-oac.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}

# Attach bucket policy to S3
resource "aws_s3_bucket_policy" "thread-bucket-oac-pol" {
  bucket = aws_s3_bucket.thread-bucket-oac.id
  policy = data.aws_iam_policy_document.allow_cloudfront.json

}
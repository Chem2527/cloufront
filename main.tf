provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.origin_type == "s3" ? aws_s3_bucket.bucket.bucket_regional_domain_name : "example.com"
    origin_id   = "myS3Origin"

    origin_shield {
      enabled = var.enable_origin_shield
    }

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = var.ipv6
  comment             = "Some comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = var.cookie_logging
    bucket          = var.logging_bucket
    prefix          = "myprefix"
  }

  default_cache_behavior {
    allowed_methods  = var.allowed_http_methods
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = var.compress_objects
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
provider "aws" {
  region = "us-west-2"
}

locals {
  origin_domain_name = {
    s3             = var.origin_type == "s3" ? aws_s3_bucket.bucket.bucket_regional_domain_name : null
    elb            = var.origin_type == "elb" ? aws_lb.elb.dns_name : null
    apigateway     = var.origin_type == "apigateway" ? "${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com" : null
    mediastore     = var.origin_type == "mediastore" ? aws_media_store_container.mediastore.endpoint : null
    mediapackage   = var.origin_type == "mediapackage" ? aws_media_package_channel.mediapackage.arn : null
    mediapackagev2 = var.origin_type == "mediapackagev2" ? aws_mediapackagev2_channel.mediapackagev2.arn : null
    vpc            = var.origin_type == "vpc" ? aws_vpc_endpoint.vpc.dns_entry[0].dns_name : null
  }
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = local.origin_domain_name[var.origin_type]
    origin_id   = "myOrigin"

    dynamic "origin_shield" {
      for_each = var.enable_origin_shield ? [1] : []
      content {
        enabled = true
      }
    }

    dynamic "custom_origin_config" {
      for_each = contains(["elb", "apigateway", "mediastore", "mediapackage", "mediapackagev2", "vpc"], var.origin_type) ? [1] : []
      content {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }

    dynamic "s3_origin_config" {
      for_each = var.origin_type == "s3" ? [1] : []
      content {
        origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
      }
    }
  }

  enabled             = true
  is_ipv6_enabled     = var.ipv6
  comment             = "CloudFront distribution for ${var.origin_type} origin"
  default_root_object = "index.html"

  logging_config {
    include_cookies = var.cookie_logging
    bucket          = var.logging_bucket
    prefix          = "myprefix"
  }

  default_cache_behavior {
    allowed_methods  = var.allowed_http_methods
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myOrigin"

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

# S3 Bucket (if origin_type is "s3")
resource "aws_s3_bucket" "bucket" {
  count  = var.origin_type == "s3" ? 1 : 0
  bucket = "my-s3-bucket-name"
}

# Elastic Load Balancer (if origin_type is "elb")
resource "aws_lb" "elb" {
  count              = var.origin_type == "elb" ? 1 : 0
  name               = "my-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-12345678", "subnet-87654321"]
}

# API Gateway (if origin_type is "apigateway")
resource "aws_api_gateway_rest_api" "api" {
  count       = var.origin_type == "apigateway" ? 1 : 0
  name        = "my-api-gateway"
  description = "API Gateway for CloudFront origin"
}

# MediaStore Container (if origin_type is "mediastore")
resource "aws_media_store_container" "mediastore" {
  count = var.origin_type == "mediastore" ? 1 : 0
  name  = "my-mediastore-container"
}

# MediaPackage Channel (if origin_type is "mediapackage")
resource "aws_media_package_channel" "mediapackage" {
  count      = var.origin_type == "mediapackage" ? 1 : 0
  id         = "my-mediapackage-channel"
  channel_id = "my-mediapackage-channel-id"
}

# MediaPackage V2 Channel (if origin_type is "mediapackagev2")
resource "aws_mediapackagev2_channel" "mediapackagev2" {
  count = var.origin_type == "mediapackagev2" ? 1 : 0
  name  = "my-mediapackagev2-channel"
}

# VPC Endpoint (if origin_type is "vpc")
resource "aws_vpc_endpoint" "vpc" {
  count             = var.origin_type == "vpc" ? 1 : 0
  vpc_id            = "vpc-12345678"
  service_name      = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type = "Gateway"
}

# CloudFront Origin Access Identity (for S3 origin)
resource "aws_cloudfront_origin_access_identity" "oai" {
  count = var.origin_type == "s3" ? 1 : 0
  comment = "OAI for S3 bucket"
}
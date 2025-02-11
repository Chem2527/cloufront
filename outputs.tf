# Output CloudFront Distribution Domain Name
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

# Output CloudFront Distribution ID
output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}

# Output S3 Bucket Domain Name (if origin_type is "s3")
output "s3_bucket_domain_name" {
  value = var.origin_type == "s3" ? aws_s3_bucket.bucket.*.bucket_regional_domain_name : null
  description = "The domain name of the S3 bucket used as the origin."
}

# Output ELB DNS Name (if origin_type is "elb")
output "elb_dns_name" {
  value = var.origin_type == "elb" ? aws_lb.elb.*.dns_name : null
  description = "The DNS name of the Elastic Load Balancer."
}

# Output API Gateway URL (if origin_type is "apigateway")
output "api_gateway_url" {
  value = var.origin_type == "apigateway" ? aws_api_gateway_rest_api.api.*.id : null
  description = "The URL of the API Gateway."
}

# Output MediaStore Endpoint (if origin_type is "mediastore")
output "mediastore_endpoint" {
  value = var.origin_type == "mediastore" ? aws_media_store_container.mediastore.*.endpoint : null
  description = "The endpoint of the MediaStore container."
}

# Output MediaPackage ARN (if origin_type is "mediapackage")
output "mediapackage_arn" {
  value = var.origin_type == "mediapackage" ? aws_media_package_channel.mediapackage.*.arn : null
  description = "The ARN of the MediaPackage channel."
}
# Output MediaPackage V2 ARN (if origin_type is "mediapackagev2")
output "mediapackagev2_arn" {
  value = var.origin_type == "mediapackagev2" ? aws_mediapackagev2_channel.mediapackagev2.*.arn : null
  description = "The ARN of the MediaPackage V2 channel."
}
# Output VPC Endpoint DNS Name (if origin_type is "vpc")
output "vpc_endpoint_dns_name" {
  value = var.origin_type == "vpc" ? aws_vpc_endpoint.vpc.*.dns_entry[0].dns_name : null
  description = "The DNS name of the VPC endpoint."
}

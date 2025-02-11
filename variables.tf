# Origin Type
variable "origin_type" {
  description = "Type of origin to use for CloudFront. Options: s3, elb, apigateway, mediastore, mediapackage, mediapackagev2, vpc."
  type        = string
  default     = "s3"
  validation {
    condition     = contains(["s3", "elb", "apigateway", "mediastore", "mediapackage", "mediapackagev2", "vpc"], var.origin_type)
    error_message = "The origin type must be one of: s3, elb, apigateway, mediastore, mediapackage, mediapackagev2, vpc."
  }
}

# Origin Shield
variable "enable_origin_shield" {
  description = "Enable or disable Origin Shield. Options: true or false."
  type        = bool
  default     = false
}

# Connection Settings
variable "connection_attempts" {
  description = "Number of connection attempts. Applicable to custom and VPC origins."
  type        = number
  default     = 3
}

variable "connection_timeout" {
  description = "Connection timeout in seconds. Applicable to custom and VPC origins."
  type        = number
  default     = 10
}

variable "response_timeout" {
  description = "Response timeout in seconds. Applicable to custom and VPC origins."
  type        = number
  default     = 30
}

variable "keep_alive_timeout" {
  description = "Keep-alive timeout in seconds. Applicable to custom and VPC origins."
  type        = number
  default     = 5
}

# Default Cache Behavior
variable "compress_objects" {
  description = "Compress objects automatically. Options: true or false."
  type        = bool
  default     = true
}

variable "viewer_protocol_policy" {
  description = "Viewer protocol policy. Options: allow-all, https-only, redirect-to-https."
  type        = string
  default     = "allow-all"
  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "The viewer protocol policy must be one of: allow-all, https-only, redirect-to-https."
  }
}

variable "allowed_http_methods" {
  description = "Allowed HTTP methods. Options: GET, HEAD or GET, HEAD, OPTIONS or GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE."
  type        = list(string)
  default     = ["GET", "HEAD"]
  validation {
    condition     = alltrue([for method in var.allowed_http_methods : contains(["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"], method)])
    error_message = "Allowed HTTP methods must be a subset of: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE."
  }
}

variable "restrict_viewer_access" {
  description = "Restrict viewer access. Options: true or false."
  type        = bool
  default     = false
}

# Cache Key
variable "cache_key" {
  description = "Cache key settings. Options: caching-optimized, caching-disabled, caching-optimized-for-uncompressed-objects, elemental-media-package, amplify, amplify-default-no-cookies, amplify-default, amplify-static-content, amplify-image-optimization, use-origin-cache-control-headers, origin-cache-control-headers-query-strings."
  type        = string
  default     = "caching-optimized"
  validation {
    condition     = contains(["caching-optimized", "caching-disabled", "caching-optimized-for-uncompressed-objects", "elemental-media-package", "amplify", "amplify-default-no-cookies", "amplify-default", "amplify-static-content", "amplify-image-optimization", "use-origin-cache-control-headers", "origin-cache-control-headers-query-strings"], var.cache_key)
    error_message = "Invalid cache key setting."
  }
}

# Origin Requests
variable "origin_requests" {
  description = "Origin request settings. Options: UseAgentReferHeaders, AllViewer, CORS-S3Origin, CORS-CustomOrigin, Elemental-MediaTailor-PersonalizedManifests."
  type        = string
  default     = "AllViewer"
  validation {
    condition     = contains(["UseAgentReferHeaders", "AllViewer", "CORS-S3Origin", "CORS-CustomOrigin", "Elemental-MediaTailor-PersonalizedManifests"], var.origin_requests)
    error_message = "Invalid origin request setting."
  }
}

# Smooth Streaming
variable "smooth_streaming" {
  description = "Enable smooth streaming. Options: true or false."
  type        = bool
  default     = false
}

# WAF
variable "use_waf" {
  description = "Use WAF. Options: true or false."
  type        = bool
  default     = false
}

# Price Class
variable "price_class" {
  description = "Price class. Options: PriceClass_All, PriceClass_200, PriceClass_100."
  type        = string
  default     = "PriceClass_All"
  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "Invalid price class."
  }
}

# HTTP Version
variable "http_version" {
  description = "Supported HTTP versions. Options: http2, http3."
  type        = string
  default     = "http2"
  validation {
    condition     = contains(["http2", "http3"], var.http_version)
    error_message = "Invalid HTTP version."
  }
}

# IPv6
variable "ipv6" {
  description = "Enable IPv6. Options: true or false."
  type        = bool
  default     = true
}

# Standard Logging
variable "standard_logging" {
  description = "Enable standard logging. Options: true or false."
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "S3 bucket for logging. Required if standard_logging is true."
  type        = string
  default     = ""
}

# Cookie Logging
variable "cookie_logging" {
  description = "Enable cookie logging. Options: true or false."
  type        = bool
  default     = false
}
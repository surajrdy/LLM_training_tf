locals {
  s3_origin_id = "S3-Origin"
  cache_min_ttl = var.cache_enable ? var.cache_min_ttl : 0
  cache_max_ttl = var.cache_enable ? var.cache_max_ttl : 0
  cache_default_ttl = var.cache_enable ? var.cache_default_ttl : 0
}

resource "aws_cloudfront_origin_access_identity" "main" {
}

resource "aws_cloudfront_distribution" "main" {
  enabled = true

  default_root_object = "index.html"

  aliases = concat([var.domain], local.dns_aliases)

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = local.s3_origin_id
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = local.cache_min_ttl
    default_ttl            = local.cache_default_ttl
    max_ttl                = local.cache_max_ttl
    compress               = var.cache_compress

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    dynamic lambda_function_association {
      for_each = var.router_enable ? [1]: []
      content {
        event_type = "origin-request"
        lambda_arn = aws_lambda_function.router[0].qualified_arn
      }
    }
  }


  origin {
    domain_name = aws_s3_bucket.origin.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = module.cert.this_acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  custom_error_response {
    error_code         = 403
    response_code      = var.on_404_code
    response_page_path = var.on_404_path
  }
}

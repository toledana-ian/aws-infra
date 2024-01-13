resource "aws_cloudfront_origin_access_identity" "app" {
  comment = "OAI for ${ aws_s3_bucket.app.bucket }"
}

resource "aws_cloudfront_distribution" "app" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [
    "${var.route_sub_domain_name}.${var.route_domain_name}"
  ]

  origin {
    domain_name = aws_s3_bucket.app.bucket_domain_name
    origin_id   = aws_s3_bucket.app.bucket
    origin_path = "/public"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.app.bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = var.tags
}
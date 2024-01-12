resource "aws_cloudfront_origin_access_identity" "dynamdev_email_blast_composer_christiantoledana_com" {
  comment = "OAI for ${ aws_s3_bucket.app_email_blast_composer.bucket }"
}

resource "aws_cloudfront_distribution" "dynamdev_email_blast_composer_christiantoledana_com" {
  enabled = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.app_email_blast_composer.bucket_domain_name
    origin_id   = aws_s3_bucket.app_email_blast_composer.bucket
    origin_path = "/public"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.dynamdev_email_blast_composer_christiantoledana_com.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.app_email_blast_composer.bucket

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
    cloudfront_default_certificate = true
  }

  tags = var.default_tags
}
#resource "aws_cloudfront_distribution" "christiantoledana_com" {
#  enabled             = true
#  is_ipv6_enabled     = true
#  default_root_object = "index.html"
#
#  origin {
#    domain_name = aws_route53_record.www_christiantoledana_com.name
#    origin_id   = aws_route53_record.www_christiantoledana_com.name
#
#    custom_origin_config {
#      http_port              = "80"
#      https_port             = "443"
#      origin_protocol_policy = "http-only"
#      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
#    }
#  }
#
#  default_cache_behavior {
#    viewer_protocol_policy = "redirect-to-https"
#    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
#    cached_methods         = ["GET", "HEAD", "OPTIONS"]
#
#    target_origin_id = aws_route53_record.www_christiantoledana_com.name
#
#    forwarded_values {
#      query_string = true
#      headers      = [
#        "Host", "CloudFront-Viewer-Country", "CloudFront-Forwarded-Proto", "CloudFront-Is-Desktop-Viewer",
#        "CloudFront-Is-Mobile-Viewer", "CloudFront-Is-Tablet-Viewer"
#      ]
#
#      cookies {
#        forward = "all"
#      }
#    }
#  }
#
#  viewer_certificate {
#    acm_certificate_arn = aws_acm_certificate_validation.christiantoledana_com.certificate_arn
#    ssl_support_method  = "sni-only"
#  }
#
#  restrictions {
#    geo_restriction {
#      restriction_type = "none"
#    }
#  }
#}
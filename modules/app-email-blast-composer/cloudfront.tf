resource "aws_cloudfront_origin_access_identity" "app" {
  comment = "origin-access-identity-${var.name}"
}

resource "aws_cloudfront_function" "basic_auth" {
  name    = "${var.name}-basic-auth"
  runtime = "cloudfront-js-2.0"
  code    = <<-EOF
    function handler(event) {
      var authHeaders = event.request.headers.authorization;

      // The Base64-encoded Auth string that should be present.
      // It is an encoding of `Basic base64([username]:[password])`
      var expected = "Basic ZHluYW06JiFlJTNONWRkJHgza150OQ==";

      // If an Authorization header is supplied and it's an exact match, pass the
      // request on through to CF/the origin without any modification.
      if (authHeaders && authHeaders.value === expected) {
        return event.request;
      }

      // But if we get here, we must either be missing the auth header or the
      // credentials failed to match what we expected.
      // Request the browser present the Basic Auth dialog.
      var response = {
        statusCode: 401,
        statusDescription: "Unauthorized",
        headers: {
          "www-authenticate": {
            value: 'Basic realm="Enter credentials for this super secure site"',
          },
        },
      };

      return response;
    }
  EOF
}

resource "aws_cloudfront_distribution" "app" {
  aliases = [
    var.route_app_sub_domain_name == "" ? var.route_domain_name : format("%s.%s", var.route_app_sub_domain_name, var.route_domain_name)
  ]

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"
  default_root_object = "index.html"

  origin {
    domain_name = aws_s3_bucket.app.bucket_regional_domain_name
    origin_id   = "${var.name}-app"
    origin_path = "/public"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.app.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = split("/", aws_api_gateway_deployment.api.invoke_url)[2]
    origin_id   = "${var.name}-api"
    origin_path = "/default"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.name}-app"
    compress         = true

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.basic_auth.arn
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    path_pattern     = "/api/*"
    target_origin_id = "${var.name}-api"

    forwarded_values {
      query_string = true
      headers      = ["Origin"]

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
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

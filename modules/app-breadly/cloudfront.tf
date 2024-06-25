resource "aws_cloudfront_origin_access_identity" "app" {
  comment = "origin-access-identity-${var.name}"
}

resource "aws_cloudfront_distribution" "frontend" {
  aliases = [
    var.route_app_sub_domain_name_frontend == "" ? var.route_domain_name : format("%s.%s", var.route_app_sub_domain_name_frontend, var.route_domain_name)
  ]

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"
  default_root_object = "index.html"

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  origin {
    domain_name = aws_s3_bucket.app.bucket_regional_domain_name
    origin_id   = "${var.name}-app"
    origin_path = "/frontend/public"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.app.cloudfront_access_identity_path
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

    dynamic "function_association" {
      for_each = var.enable_digest_authentication_frontend ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.digest_authentication[0].arn
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

resource "aws_cloudfront_distribution" "mint_tracker" {
  aliases = [
      var.route_app_sub_domain_name_mint_tracker == "" ? var.route_domain_name : format("%s.%s", var.route_app_sub_domain_name_mint_tracker, var.route_domain_name)
  ]

  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"
  default_root_object = "index.html"

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  origin {
    domain_name = aws_s3_bucket.app.bucket_regional_domain_name
    origin_id   = "${var.name}-app"
    origin_path = "/mint-tracker/public"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.app.cloudfront_access_identity_path
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

    dynamic "function_association" {
      for_each = var.enable_digest_authentication_mint_tracker ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.digest_authentication[0].arn
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

resource "aws_cloudfront_key_value_store" "credentials_store" {
  count = var.enable_digest_authentication_frontend || var.enable_digest_authentication_mint_tracker ? 1 : 0
  name = "${var.name}-credentials-store"
}

resource "aws_cloudfront_function" "digest_authentication" {
  count = var.enable_digest_authentication_frontend || var.enable_digest_authentication_mint_tracker ? 1 : 0
  name    = "${var.name}-digest-authentication"
  runtime = "cloudfront-js-2.0"

  key_value_store_associations = [
    aws_cloudfront_key_value_store.credentials_store[0].arn
  ]

  code = <<-EOF
    const crypto = require('crypto');
    const cf = require('cloudfront');

    const credentialsStore = cf.kvs("${local.aws_cloudfront_key_value_store_credentials_store_id}");

    async function handler(event) {
      var request = event.request;
      var authHeaders = request.headers['authorization'];

      if (!authHeaders || !authHeaders.value) {
        return sendUnauthorizedResponse();
      }

      const credentials = parseDigestHeader(authHeaders.value);

      let password = "";
      try{
        password = await credentialsStore.get(credentials.username);
      } catch(_){
        return sendUnauthorizedResponse();
      }

      const expectedResponse = generateDigestResponse(credentials, 'GET', password);

      if (credentials.response !== expectedResponse) {
        return sendUnauthorizedResponse();
      }

      return request;
    }

    function parseDigestHeader(header) {
      const parts = header.slice(7).split(',').reduce((acc, current) => {
        const splitPoint = current.trim().indexOf('='); // Find the index of the first equals sign
        const key = current.trim().substring(0, splitPoint); // Extract the key
        const value = current.trim().substring(splitPoint + 1).replace(/"/g, ''); // Extract the value, removing quotes
        acc[key] = value;
        return acc;
      }, {});

      return parts;
    }

    function generateDigestResponse(credentials, method, password) {
      var username = credentials.username;
      var realm = credentials.realm;
      var nonce = credentials.nonce;
      var uri = credentials.uri;
      var qop = credentials.qop;
      var nc = credentials.nc;
      var cnonce = credentials.cnonce;

      var ha1 = crypto.createHash('md5').update(username + ':' + realm + ':' + password).digest('hex');
      var ha2 = crypto.createHash('md5').update(method + ':' + uri).digest('hex');
      var response = crypto.createHash('md5').update(ha1 + ':' + nonce + ':' + nc + ':' + cnonce + ':' + qop + ':' + ha2).digest('hex');
      return response;
    }

    function sendUnauthorizedResponse() {
      var nonce = generateNonce();
      var opaque = generateOpaque();
      var unauthorizedResponse = {
        statusCode: 401,
        statusDescription: 'Unauthorized',
        headers: {
          'www-authenticate': {
            value: 'Digest realm="Access to the site", qop="auth", nonce="'+nonce+'", opaque="'+opaque+'"'
          },
          'content-type': {
            value: 'text/html'
          }
        },
        body: 'Unauthorized access.'
      };
      return unauthorizedResponse;
    }

    function generateRandomString(length) {
      var result = '';
      var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      var charactersLength = characters.length;
      for (var i = 0; i < length; i++) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
      }
      return result;
    }

    function generateOpaque() {
      return generateRandomString(16);
    }

    function generateNonce() {
      return generateRandomString(32);
    }
  EOF
}

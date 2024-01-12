resource "aws_s3_bucket" "app_email_blast_composer" {
  bucket = "app-email-blast-composer-prod-frontend"
  tags = var.default_tags
}

resource "aws_s3_bucket_policy" "app_email_blast_composer" {
  bucket = aws_s3_bucket.app_email_blast_composer.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.dynamdev_email_blast_composer_christiantoledana_com.id}"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.app_email_blast_composer.id}/public/*"
      }
    ]
  })
}
resource "aws_s3_bucket" "app" {
  bucket = var.name
  tags = var.tags
}

resource "aws_s3_bucket_policy" "app" {
  bucket = aws_s3_bucket.app.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontAccess"
        Action   = "s3:GetObject"
        Effect    = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.app.id}/public/*"
        "Principal": {
          "AWS": [
            "${aws_cloudfront_origin_access_identity.app.iam_arn}"
          ]
        }
      }
    ]
  })
}
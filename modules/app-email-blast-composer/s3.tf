resource "random_string" "random_suffix" {
  length  = 6
  special = false
}

resource "aws_s3_bucket" "app" {
  bucket = "${var.name}-${random_string.random_suffix.result}"
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "app" {
  bucket = aws_s3_bucket.app.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": aws_cloudfront_origin_access_identity.app.iam_arn
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::${aws_s3_bucket.app.bucket}/public/*"
      }
    ]
  })
}
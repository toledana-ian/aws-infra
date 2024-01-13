resource "aws_s3_bucket" "app" {
  bucket = var.name
  tags   = var.tags
}

resource "aws_s3_bucket_policy" "app" {
  bucket = aws_s3_bucket.app.bucket

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Sid = "AllowCloudFrontAccess"
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.app.bucket}/public/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.app.arn
          }
        }
      }
    ]
  })
}
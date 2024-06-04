data "aws_s3_object" "lambda_zip"{
  bucket = aws_s3_bucket.app.arn
  key    = "lambdas.zip"
}

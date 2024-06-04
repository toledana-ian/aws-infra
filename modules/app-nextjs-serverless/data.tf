data "aws_s3_object" "lambda_zip"{
  count = var.is_lamba_zip_uploaded ? 1 : 0

  bucket = aws_s3_bucket.app.bucket
  key    = local.lambda_zip_filename
}

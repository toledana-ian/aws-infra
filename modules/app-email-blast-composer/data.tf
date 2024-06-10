data "external" "get_lambda_list" {
  program = [
    "bash", "${path.module}/scripts/list_s3_zip_contents.sh", aws_s3_bucket.app.bucket, local.lambda_zip_filename
  ]
}

data "aws_s3_object" "lambda_zip"{
  bucket = aws_s3_bucket.app.bucket
  key    = local.lambda_zip_filename
}

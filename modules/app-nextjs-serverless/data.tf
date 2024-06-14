data "external" "get_lambda_list" {
  program = [
    "bash", "${path.module}/scripts/list_s3_zip_contents.sh", local.s3_bucket_name, local.lambda_zip_filename
  ]
}

data "aws_s3_object" "lambda_zip"{
  count = local.is_lamba_zip_uploaded ? 1 : 0

  bucket = aws_s3_bucket.app.bucket
  key    = local.lambda_zip_filename
}

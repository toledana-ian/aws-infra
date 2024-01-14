data "external" "get_lambda_list" {
  program = ["bash", "${path.module}/scripts/list_s3_zip_contents.sh", aws_s3_bucket.app.bucket, local.lambda_zip_filename]
}
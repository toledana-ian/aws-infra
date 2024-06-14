locals {
  // Name of the s3 bucket by combining project name and s3 random string suffix
  s3_bucket_name = "${var.name}-${var.random_suffix}"

  // Name of the ZIP file where the AWS Lambda functions' code is stored
  lambda_zip_filename = "lambda.zip"

  // List of all available Lambda functions. These are retrieved by calling external data source "get_lambda_list"
  lambda_functions = keys(data.external.get_lambda_list.result)

  is_lambda_zip_uploaded = length(local.lambda_functions)!=0

  // Get the  last segment of the ARN of the credentials_store of aws_cloudfront_key_value_store
  aws_cloudfront_key_value_store_credentials_store_id = var.enable_digest_authentication ? element(split("/", aws_cloudfront_key_value_store.credentials_store[0].arn), length(split("/", aws_cloudfront_key_value_store.credentials_store[0].arn)) - 1) : ""
}

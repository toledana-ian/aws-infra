locals {
  // Get the  last segment of the ARN of the credentials_store of aws_cloudfront_key_value_store
  aws_cloudfront_key_value_store_credentials_store_id = var.enable_digest_authentication ? element(split("/", aws_cloudfront_key_value_store.credentials_store[0].arn), length(split("/", aws_cloudfront_key_value_store.credentials_store[0].arn)) - 1) : ""
}

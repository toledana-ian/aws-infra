locals {
  // Name of the ZIP file where the AWS Lambda functions' code is stored
  lambda_zip_filename = "lambdas.zip"

  // List of all available Lambda functions. These are retrieved by calling external data source "get_lambda_list"
  lambda_functions = keys(data.external.get_lambda_list.result)

  // List of complex lambda functions. Currently, this list is manually maintained
  lambda_complex_functions = []

  // List of simple rest lambda functions. This list is derived by excluding the complex functions from the list of all lambda functions
  lambda_simple_rest_functions = setsubtract(local.lambda_functions, local.lambda_complex_functions)

  // Get the  last segment of the ARN of the credentials_store of aws_cloudfront_key_value_store
  aws_cloudfront_key_value_store_credentials_store_id = var.enable_digest_authentication && length(local.lambda_functions)!=0 ? element(split("/", aws_cloudfront_key_value_store.credentials_store[0].arn), length(split("/", aws_cloudfront_key_value_store.credentials_store[0].arn)) - 1) : ""
}

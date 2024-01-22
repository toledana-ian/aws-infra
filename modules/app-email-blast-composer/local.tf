locals {
  // Name of the ZIP file where the AWS Lambda functions' code is stored
  lambda_zip_filename = "lambdas.zip"

  // List of all available Lambda functions. These are retrieved by calling external data source "get_lambda_list"
  lambda_functions = keys(data.external.get_lambda_list.result)

  // Hash of the source code retrieved from external data source "get_lambda_source_code_hash"
  lambda_source_code_hash =  data.external.get_lambda_source_code_hash.result["source_code_hash"]

  // List of complex lambda functions. Currently, this list is manually maintained
  lambda_complex_functions = []

  // List of simple rest lambda functions. This list is derived by excluding the complex functions from the list of all lambda functions
  lambda_simple_rest_functions = setsubtract(local.lambda_functions, local.lambda_complex_functions)
}
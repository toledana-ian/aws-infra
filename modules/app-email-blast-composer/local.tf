locals {
  lambda_zip_filename = "lambdas.zip"

  lambda_functions = keys(data.external.get_lambda_list.result)

  lambda_source_code_hash =
}
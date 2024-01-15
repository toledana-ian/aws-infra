locals {
  lambda_zip_filename = "lambdas.zip"

  lambda_functions = keys(data.external.get_lambda_list.result)

  lambda_source_code_hash =  data.external.get_lambda_source_code_hash.result["source_code_hash"]

  api_gateway_domain = split("/", aws_api_gateway_deployment.api.invoke_url)[2]
}
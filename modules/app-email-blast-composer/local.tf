locals {
  // the domain of the api gateway
  api_gateway_domain = split("/", aws_api_gateway_deployment.api.invoke_url)[2]

  sqs_email_domain = split("/", aws_sqs_queue.email.url)[2]

  // name of the file where the lambdas are stored
  lambda_zip_filename = "lambdas.zip"

  // hash of the source code for the lambda
  lambda_source_code_hash =  data.external.get_lambda_source_code_hash.result["source_code_hash"]

  // list of simple rest lambda functions obtained by excluding the complex ones from the full set
  lambda_functions = keys(data.external.get_lambda_list.result)

  // list of complex lambda functions
  lambda_complex_functions = ["send-email", "queue-email"]

  lambda_simple_rest_functions = setsubtract(local.lambda_functions, local.lambda_complex_functions)
}
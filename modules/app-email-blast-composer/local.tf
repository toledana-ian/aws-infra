locals {
  // name of the file where the lambdas are stored
  lambda_zip_filename = "lambdas.zip"

  // list of simple rest lambda functions obtained by excluding the complex ones from the full set
  lambda_functions = keys(data.external.get_lambda_list.result)

  // hash of the source code for the lambda
  lambda_source_code_hash =  data.external.get_lambda_source_code_hash.result["source_code_hash"]

  // list of complex lambda functions
  lambda_complex_functions = []

  // list of simple rest lambda functions
  lambda_simple_rest_functions = setsubtract(local.lambda_functions, local.lambda_complex_functions)
}
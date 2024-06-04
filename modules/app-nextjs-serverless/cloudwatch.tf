resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/api_gateway/${aws_api_gateway_rest_api.api.name}"
  retention_in_days = 1

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lambda_rest" {
  count        = var.is_lamba_zip_uploaded ? 1 : 0

  name              = "/aws/lambda/${aws_lambda_function.lambda_rest[1].function_name}"
  retention_in_days = 7

  tags = var.tags
}

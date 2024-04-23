resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/api_gateway/${aws_api_gateway_rest_api.api.name}"
  retention_in_days = 1

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  name              = "/aws/lambda/${aws_lambda_function.simple_rest[each.value].function_name}"
  retention_in_days = 7

  tags = var.tags
}

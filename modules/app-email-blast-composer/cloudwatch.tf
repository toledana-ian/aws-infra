resource "aws_cloudwatch_log_group" "api" {
  for_each = toset(local.lambda_simple_rest_functions)

  name              = "/aws/lambda/${aws_lambda_function.api[each.value].function_name}"
  retention_in_days = 7

  tags = var.tags
}


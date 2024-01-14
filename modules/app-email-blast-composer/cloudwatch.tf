resource "aws_cloudwatch_log_group" "app" {
  for_each = toset(local.lambda_functions)

  name              = "/aws/lambda/${aws_lambda_function.app[each.value].function_name}"
  retention_in_days = 30

  tags = var.tags
}
resource "aws_cloudwatch_log_group" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  name              = "/aws/lambda/${aws_lambda_function.simple_rest[each.value].function_name}"
  retention_in_days = 7

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "queue_email" {
  count = contains(local.lambda_functions, "queue-email") ? 1 : 0

  name              = "/aws/lambda/${aws_lambda_function.queue_email[count.index].function_name}"
  retention_in_days = 7

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "send_email" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  name              = "/aws/lambda/${aws_lambda_function.send_email[count.index].function_name}"
  retention_in_days = 7

  tags = var.tags
}
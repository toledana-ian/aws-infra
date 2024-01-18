resource "aws_cloudwatch_log_group" "send_email" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  name              = "/aws/lambda/${aws_lambda_function.send_email[count.index].function_name}"
  retention_in_days = 7

  tags = var.tags
}
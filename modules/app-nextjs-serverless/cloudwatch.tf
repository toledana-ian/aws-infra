resource "aws_cloudwatch_log_group" "api_gateway" {
  name              = "/aws/api_gateway/${aws_apigatewayv2_api.nextjs_api.name}"
  retention_in_days = 1

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "nextjs_api" {
  count        = var.is_lamba_zip_uploaded ? 1 : 0

  name              = "/aws/lambda/${aws_lambda_function.nextjs_api[1].function_name}"
  retention_in_days = 7

  tags = var.tags
}

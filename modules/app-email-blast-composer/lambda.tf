resource "aws_lambda_function" "send_email" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  function_name = "${var.name}-send-email"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "send-email.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.api.arn

  environment {
    variables = {
      SENDGRID_SECRET_NAME = aws_secretsmanager_secret.sendgrid.name
    }
  }

  tags = var.tags
}

resource "aws_lambda_permission" "send_email" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  function_name = aws_lambda_function.send_email[count.index].function_name
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
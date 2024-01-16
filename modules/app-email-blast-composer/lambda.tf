resource "aws_lambda_function" "api_simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  function_name = "${var.name}-${each.value}"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "${each.value}.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.api.arn

  lifecycle {
    ignore_changes = [
      source_code_hash,
    ]
  }

  tags = var.tags
}

resource "aws_lambda_permission" "api_simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  function_name = aws_lambda_function.api_simple_rest[each.value].function_name
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_function" "api_queue_email" {
  function_name = "${var.name}-queue-email"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "queue-email.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.api.arn

  lifecycle {
    ignore_changes = [
      source_code_hash,
    ]
  }

  tags = var.tags
}

resource "aws_lambda_permission" "api_queue_email" {
  function_name = aws_lambda_function.api_queue_email.function_name
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_function" "api_send_email" {
  function_name = "${var.name}-send-email"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "send-email.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.api.arn

  lifecycle {
    ignore_changes = [
      source_code_hash,
    ]
  }

  tags = var.tags
}

resource "aws_lambda_permission" "api_send_email" {
  function_name = aws_lambda_function.api_send_email.function_name
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
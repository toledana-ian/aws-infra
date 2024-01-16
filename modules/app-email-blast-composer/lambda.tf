resource "aws_lambda_function" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  function_name = "${var.name}-${each.value}"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "${each.value}.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.api.arn

  tags = var.tags
}

resource "aws_lambda_permission" "simple_rest_trigger" {
  for_each = toset(local.lambda_simple_rest_functions)

  function_name = aws_lambda_function.simple_rest[each.value].function_name
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_function" "queue_email" {
  count = contains(local.lambda_functions, "queue-email") ? 1 : 0

  function_name = "${var.name}-queue-email"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "queue-email.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.api.arn

  environment {
    variables = {
      QUEUE_URL            = aws_sqs_queue.email.url
    }
  }

  tags = var.tags
}

resource "aws_lambda_permission" "queue_email_trigger" {
  count = contains(local.lambda_functions, "queue-email") ? 1 : 0

  function_name = aws_lambda_function.queue_email[count.index].function_name
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

#resource "aws_lambda_function_event_invoke_config" "queue_email_destination" {
#  count = contains(local.lambda_functions, "queue-email") ? 1 : 0
#
#  function_name = aws_lambda_function.queue_email[count.index].function_name
#
#  destination_config {
#    on_success {
#      destination = aws_sqs_queue.email.arn
#    }
#  }
#}

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

resource "aws_lambda_event_source_mapping" "send_email_trigger" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  event_source_arn = aws_sqs_queue.email.arn
  function_name    = aws_lambda_function.send_email[count.index].arn
}
resource "aws_lambda_function" "app" {
  for_each = toset(local.lambda_functions)

  function_name = "${var.name}-${each.value}"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "${each.value}.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.lambda.arn

  lifecycle {
    ignore_changes = [
      source_code_hash,
    ]
  }

  tags = var.tags
}

resource "aws_lambda_permission" "allow_api_gateway" {
  for_each = toset(local.lambda_functions)

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app[each.value].function_name
  principal     = "apigateway.amazonaws.com"

  // This is important - the source ARN should match the ARN of the API method calling the Lambda
  source_arn    = "${aws_api_gateway_rest_api.app.execution_arn}/*/*"
}
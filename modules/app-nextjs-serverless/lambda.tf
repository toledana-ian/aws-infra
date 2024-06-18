resource "aws_lambda_function" "simple_rest" {
  for_each = toset(local.lambda_functions)

  function_name = "${var.name}-${each.value}"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "${each.value}.handler"
  timeout = 10

  source_code_hash = data.aws_s3_object.lambda_zip[0].etag
  role             = aws_iam_role.lambda.arn

  tags = var.tags
}

resource "aws_lambda_permission" "simple_rest_trigger" {
  for_each = toset(local.lambda_functions)

  function_name = aws_lambda_function.simple_rest[each.value].function_name
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

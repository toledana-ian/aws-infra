resource "aws_lambda_function" "lambda_rest" {
  count = local.is_lambda_zip_uploaded ? 1 : 0

  function_name = "${var.name}-nextjs-api"
  s3_bucket     = data.aws_s3_object.lambda_zip[0].bucket
  s3_key        = data.aws_s3_object.lambda_zip[0].key

  runtime = "nodejs18.x"
  handler = "server.handler"
  timeout = 10

  source_code_hash = data.aws_s3_object.lambda_zip[0].etag
  role             = aws_iam_role.lambda.arn

  tags = var.tags
}

resource "aws_lambda_permission" "lambda_rest" {
  count        = local.is_lambda_zip_uploaded ? 1 : 0

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_rest[0].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

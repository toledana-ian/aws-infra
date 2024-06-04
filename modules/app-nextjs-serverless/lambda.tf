resource "aws_lambda_function" "lambda_rest" {
  count = var.is_lamba_zip_uploaded ? 1 : 0

  function_name = "${var.name}-nextjs-api"
  s3_bucket     = data.aws_s3_object.lambda_zip[1].bucket
  s3_key        = data.aws_s3_object.lambda_zip[1].key

  runtime = "nodejs18.x"
  handler = "index.handler"
  timeout = 10

  source_code_hash = filebase64sha256(data.aws_s3_object.lambda_zip[1].body)
  role             = aws_iam_role.lambda.arn

  tags = var.tags
}

resource "aws_lambda_permission" "lambda_rest" {
  count        = var.is_lamba_zip_uploaded ? 1 : 0

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_rest[1].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

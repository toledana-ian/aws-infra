resource "aws_lambda_function" "nextjs_api" {
  count = local.is_lambda_zip_file_exists != "" ? 1 : 0

  function_name = "${var.name}-nextjs-api"
  s3_bucket     = data.aws_s3_object.lambda_zip.bucket
  s3_key        = data.aws_s3_object.lambda_zip.key

  runtime = "nodejs18.x"
  handler = "index.handler"
  timeout = 10

  source_code_hash = filebase64sha256(data.aws_s3_object.lambda_zip.body)
  role             = aws_iam_role.lambda.arn

  tags = var.tags
}

resource "aws_lambda_permission" "apigw_lambda" {
  count        = local.is_lambda_zip_file_exists != "" ? 1 : 0

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nextjs_api[1].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.nextjs_api.execution_arn}/*/*"
}

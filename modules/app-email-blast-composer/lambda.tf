resource "aws_lambda_function" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  function_name = "${var.name}-${each.value}"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "${each.value}.handler"
  timeout = 10

  source_code_hash = local.lambda_source_code_hash
  role             = aws_iam_role.lambda.arn

  environment {
    variables = {
      SENDGRID_SECRET_NAME = aws_secretsmanager_secret.sendgrid.name
    }
  }

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

resource "aws_lambda_function" "cloudfront_basic_auth" {
  function_name = "${var.name}-cloudfront-basic-auth"

  runtime = "nodejs18.x"
  handler = "index.handler"
  timeout = 10
  role    = aws_iam_role.lambda.arn
  publish = true


  filename = data.archive_file.lambda_cloudfront_basic_auth_soruce_code.output_path
  source_code_hash = data.archive_file.lambda_cloudfront_basic_auth_soruce_code.output_base64sha256

  environment {
    variables = {
      SENDGRID_SECRET_NAME = aws_secretsmanager_secret.sendgrid.name
    }
  }

  tags = var.tags
}

resource "aws_lambda_permission" "cloudfront_basic_auth_execution" {
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudfront_basic_auth.arn
  principal     = "edgelambda.amazonaws.com"
  source_arn    = aws_cloudfront_distribution.app.arn
}

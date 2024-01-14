resource "aws_lambda_function" "app" {
  for_each = toset(local.lambda_functions)

  function_name = "${var.name}-${each.value}"
  s3_bucket     = aws_s3_bucket.app.id
  s3_key        = local.lambda_zip_filename

  runtime = "nodejs18.x"
  handler = "dist/${each.value}.handler"
  timeout = 10

  source_code_hash = "haha"
  role             = aws_iam_role.lambda.arn

  lifecycle {
    ignore_changes = [
      source_code_hash,
    ]
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "app" {
  for_each = toset(local.lambda_functions)

  name              = "/aws/lambda/${aws_lambda_function.app[each.value].function_name}"
  retention_in_days = 30

  tags = var.tags
}
resource "aws_api_gateway_rest_api" "app" {
  name        = aws_s3_bucket.app.bucket
  description = "Lambda API of ${aws_s3_bucket.app.bucket}"
}

resource "aws_api_gateway_resource" "app" {
  for_each = toset(local.lambda_functions)

  rest_api_id = aws_api_gateway_rest_api.app.id
  parent_id   = aws_api_gateway_rest_api.app.root_resource_id
  path_part   = each.value
}

resource "aws_api_gateway_method" "app" {
  for_each = toset(local.lambda_functions)

  rest_api_id   = aws_api_gateway_rest_api.app.id
  resource_id   = aws_api_gateway_resource.app[each.value].id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "app" {
  for_each = toset(local.lambda_functions)

  rest_api_id             = aws_api_gateway_rest_api.app.id
  resource_id             = aws_api_gateway_resource.app[each.value].id
  http_method             = aws_api_gateway_method.app[each.value].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.app[each.value].invoke_arn
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.app
  ]
  rest_api_id = aws_api_gateway_rest_api.app.id
  stage_name  = var.tags.Environment
}
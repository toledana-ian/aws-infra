resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "Lambda API of ${var.name}"

  tags = var.tags
}

resource "aws_api_gateway_resource" "send_email" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "send-email"
}

resource "aws_api_gateway_method" "send_email" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.send_email[count.index].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "send_email" {
  count = contains(local.lambda_functions, "send-email") ? 1 : 0

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.send_email[count.index].id
  http_method             = aws_api_gateway_method.send_email[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.send_email[count.index].invoke_arn
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_integration.send_email
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "default"
}
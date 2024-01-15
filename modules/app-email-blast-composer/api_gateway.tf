resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "Lambda API of ${var.name}"

  tags = var.tags
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_integration.simple_rest_api
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "default"
}

resource "aws_api_gateway_resource" "simple_rest_api" {
  for_each = toset(local.lambda_simple_rest_functions)

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = each.value
}

resource "aws_api_gateway_method" "simple_rest_api" {
  for_each = toset(local.lambda_simple_rest_functions)

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.simple_rest_api[each.value].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "simple_rest_api" {
  for_each = toset(local.lambda_simple_rest_functions)

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.simple_rest_api[each.value].id
  http_method             = aws_api_gateway_method.simple_rest_api[each.value].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api[each.value].invoke_arn
}

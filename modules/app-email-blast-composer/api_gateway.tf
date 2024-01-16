resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "Lambda API of ${var.name}"

  tags = var.tags
}

resource "aws_api_gateway_deployment" "api" {
  depends_on = [
    aws_api_gateway_integration.simple_rest
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "default"
}

//########## SIMPLE REST RESOURCE ##########

resource "aws_api_gateway_resource" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = each.value
}

resource "aws_api_gateway_method" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.simple_rest[each.value].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.simple_rest[each.value].id
  http_method             = aws_api_gateway_method.simple_rest[each.value].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.simple_rest[each.value].invoke_arn
}

//########## QUEUE EMAIL RESOURCE ##########

resource "aws_api_gateway_resource" "queue_email" {
  count = contains(local.lambda_functions, "queue-email") ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "queue-email"
}

resource "aws_api_gateway_method" "queue_email" {
  count = contains(local.lambda_functions, "queue-email") ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.queue_email[count.index].id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "queue_email" {
  count = contains(local.lambda_functions, "queue-email") ? 1 : 0

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.queue_email[count.index].id
  http_method             = aws_api_gateway_method.queue_email[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.queue_email[count.index].invoke_arn
}
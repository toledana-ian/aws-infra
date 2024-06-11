resource "aws_api_gateway_account" "app" {
  cloudwatch_role_arn = aws_iam_role.api_gateway.arn
}

resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "Lambda API of ${var.name}"

  tags = var.tags
}

//########## API DEPLOYMENT ##########

resource "aws_api_gateway_deployment" "api" {
  count = length(local.lambda_functions)!=0 ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_method.simple_rest,
    aws_api_gateway_integration.simple_rest,
    aws_api_gateway_resource.api,
    aws_api_gateway_resource.simple_rest
  ]
}

resource "aws_api_gateway_stage" "api" {
  count = length(local.lambda_functions)!=0 ? 1 : 0

  stage_name    = "default"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api[0].id

  xray_tracing_enabled = true

  # Enable logging
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gateway.arn
    format          = jsonencode({
      "requestId" : "$context.requestId",
      "ip" : "$context.identity.sourceIp",
      "caller" : "$context.identity.caller",
      "user" : "$context.identity.user",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "resourcePath" : "$context.resourcePath",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength"
    })
  }
}

//########## API ROOT RESOURCE ##########

resource "aws_api_gateway_resource" "api" {
  count = length(local.lambda_functions)!=0 ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "api"

  depends_on = [aws_lambda_function.simple_rest]
}

//########## SIMPLE REST RESOURCE ##########

resource "aws_api_gateway_resource" "simple_rest" {
  for_each = toset(local.lambda_simple_rest_functions)

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.api[0].id
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
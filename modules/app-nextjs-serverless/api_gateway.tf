resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "Lambda API of ${var.name}"

  tags = var.tags
}

//########## API DEPLOYMENT ##########

resource "aws_api_gateway_deployment" "api" {
  count = var.is_lamba_zip_uploaded ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "api" {
  count = var.is_lamba_zip_uploaded ? 1 : 0

  stage_name    = "default"
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api[1].id

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

//########## LAMBDA REST RESOURCE ##########

resource "aws_api_gateway_resource" "lambda_rest" {
  count = var.is_lamba_zip_uploaded ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "*"
}

resource "aws_api_gateway_method" "lambda_rest" {
  count = var.is_lamba_zip_uploaded ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.lambda_rest[1].id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_rest" {
  count = var.is_lamba_zip_uploaded ? 1 : 0

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.lambda_rest[1].id
  http_method             = aws_api_gateway_method.lambda_rest[1].http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_rest[1].invoke_arn
}

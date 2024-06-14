resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "Lambda API of ${var.name}"

  tags = var.tags
}

//########## API DEPLOYMENT ##########

resource "aws_api_gateway_deployment" "api" {
  count = local.is_lambda_zip_uploaded ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_method.lambda_rest,
    aws_api_gateway_integration.lambda_rest,
    aws_api_gateway_resource.lambda_rest
  ]
}

resource "aws_api_gateway_stage" "api" {
  count = local.is_lambda_zip_uploaded ? 1 : 0

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

# //########## API ROOT RESOURCE ##########
#
# resource "aws_api_gateway_resource" "api" {
#   count = local.is_lambda_zip_uploaded ? 1 : 0
#
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   parent_id   = aws_api_gateway_rest_api.api.root_resource_id
#   path_part   = "api"
#
#   depends_on = [aws_lambda_function.lambda_rest]
# }

//########## LAMBDA REST RESOURCE ##########

resource "aws_api_gateway_resource" "lambda_rest" {
  count = local.is_lambda_zip_uploaded ? 1 : 0

  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_method" "lambda_rest" {
  count = local.is_lambda_zip_uploaded ? 1 : 0

  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.lambda_rest[0].id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_rest" {
  count = local.is_lambda_zip_uploaded ? 1 : 0

  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.lambda_rest[0].id
  http_method             = aws_api_gateway_method.lambda_rest[0].http_method
  integration_http_method = "ANY"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_rest[0].invoke_arn
}

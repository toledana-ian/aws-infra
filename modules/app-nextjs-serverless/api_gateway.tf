resource "aws_api_gateway_account" "nextjs_api" {
  cloudwatch_role_arn = aws_iam_role.api_gateway.arn
}

resource "aws_apigatewayv2_api" "nextjs_api" {
  name          = "nextjs-api-gateway"
  protocol_type = "HTTP"
}


//########## API DEPLOYMENT ##########

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_apigatewayv2_api.nextjs_api.id
}

resource "aws_api_gateway_stage" "api" {
  stage_name    = "default"
  rest_api_id   = aws_apigatewayv2_api.nextjs_api.id
  deployment_id = aws_api_gateway_deployment.api.id

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

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.nextjs_api.id
  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.nextjs_api.arn
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id = aws_apigatewayv2_api.nextjs_api.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

locals {
  api_gateway_name = "test-http2-api"
  env              = "dev"
}

resource "aws_apigatewayv2_api" "main" {
  name          = local.api_gateway_name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "main" {
  api_id      = aws_apigatewayv2_api.main.id
  name        = local.env
  auto_deploy = true
}

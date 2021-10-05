locals {
  api_gateway_name = "test-http2-api"
}
resource "aws_apigatewayv2_api" "main" {
  name          = local.api_gateway_name
  protocol_type = "HTTP"
}

locals {
  api_gateway_name = "test-http2-api"
  env              = "dev"
}

data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/hello-world.zip"
}


resource "aws_lambda_function" "hello_world" {
  function_name = "HelloWorld"
  filename      = data.archive_file.lambda_hello_world.output_path

  runtime = "nodejs12.x"
  handler = "hello.handler"

  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256

  role        = aws_iam_role.lambda_exec.arn
  memory_size = 128
}

resource "aws_cloudwatch_log_group" "hello_world" {
  name              = "/aws/lambda/${aws_lambda_function.hello_world.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
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

resource "aws_apigatewayv2_integration" "main" {
  api_id           = aws_apigatewayv2_api.main.id
  integration_type = "HTTP_PROXY"
  //integration_uri    = "https://example.com/{proxy}"
  integration_uri    = aws_lambda_function.hello_world.invoke_arn
  integration_method = "POST"
}


resource "aws_apigatewayv2_route" "main" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "ANY /api/{proxy+}"

  target = "integrations/${aws_apigatewayv2_integration.main.id}"
}

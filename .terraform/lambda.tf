locals {
  app_name = "${var.group}-${var.env}-${var.app_name}"
}

resource "aws_lambda_function" "app" {
  filename         = data.archive_file.src.output_path
  function_name    = local.app_name
  role             = aws_iam_role.lambda.arn
  handler          = "LambdaForS3::LambdaForS3.Function::FunctionHandler"
  source_code_hash = data.archive_file.src.output_base64sha256
  runtime          = "dotnetcore3.1"
  memory_size      = 128

  environment {
    variables = {
      foo = "bar"
    }
  }

  tags = {
    Group = var.group
    Env   = var.env
    Name  = local.app_name
  }
}

data "archive_file" "src" {
  output_path = "${path.module}/publish/lambda.zip"
  source_dir  = "${path.module}/../publish"
  excludes    = ["__init__.py", "*.pyc"]
  type        = "zip"
}

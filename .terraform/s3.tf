variable "s3_bucket_name" {
  type    = string
  default = "ruhul-test-s3-event"
}

data "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.this.arn
}

resource "aws_s3_bucket_notification" "s3_trigger" {
  depends_on = [
    aws_lambda_permission.allow_bucket
  ]

  bucket = data.aws_s3_bucket.this.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.app.arn
    events              = ["s3:ObjectCreated:*"]
  }
}


variable "dynamodb_table_name" {
  type    = string
  default = ""
}

data "aws_dynamodb_table" "this" {
  name = var.dynamodb_table_name
}

resource "aws_iam_role_policy" "this" {
  name   = "${var.group}-${var.env}-${var.app_name}-role-policy"
  role   = aws_iam_role.lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [ "logs:*" ],
        "Effect": "Allow",
        "Resource": [ "arn:aws:logs:*:*:*" ]
    },
    {
        "Action": [ "dynamodb:BatchGetItem",
                    "dynamodb:GetItem",
                    "dynamodb:GetRecords",
                    "dynamodb:Scan",
                    "dynamodb:Query",
                    "dynamodb:GetShardIterator",
                    "dynamodb:DescribeStream",
                    "dynamodb:ListStreams" ],
        "Effect": "Allow",
        "Resource": [
          "${aws_dynamodb_table.this.arn}",
          "${aws_dynamodb_table.this.arn}/*"
        ]
    }
  ]
}
EOF
}

resource "aws_lambda_event_source_mapping" "this" {
  depends_on = [
    aws_iam_role_policy.this
  ]
  function_name     = aws_lambda_function.app.arn
  event_source_arn  = data.aws_dynamodb_table.this.stream_arn
  starting_position = "LATEST"
}



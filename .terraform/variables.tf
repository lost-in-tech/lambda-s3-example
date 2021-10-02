variable "group" {
  type    = string
  default = "retail"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "ruhul-s3-example"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "lambda_src" {
  type    = string
  default = "src.zip"
}

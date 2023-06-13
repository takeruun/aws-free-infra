locals {
  bucket_name  = "${var.app_name}-s3-images"
  s3_origin_id = "S3-Images-${var.app_name}"
  account_id   = data.aws_caller_identity.user.account_id
}

variable "app_name" {}

variable "domain" {}

variable "image_domain" {}

variable "aws_region" {}

variable "aws_profile" {}

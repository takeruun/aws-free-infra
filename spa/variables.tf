locals {
  bucket_name  = "${var.app_name}-s3"
  s3_origin_id = "S3-${var.app_name}"
}

variable "app_name" {}

variable "domain" {}

variable "aws_region" {}

variable "aws_profile" {}

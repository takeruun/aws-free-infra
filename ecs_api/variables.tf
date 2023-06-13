variable "app_name" {}

variable "rds_db_name" {}

variable "rds_username" {}

variable "rds_password" {}

variable "token_key" {}

variable "remote_state_bucket" {}

variable "domain" {}

variable "s3_user_aws_access_key_id" {}

variable "s3_user_aws_secret_access_key" {}

variable "containers_name" {
  default = ["aws-free-infra_api"]
}

variable "aws_region" {}

variable "aws_profile" {}

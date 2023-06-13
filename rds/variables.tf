variable "app_name" {}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.28"
}

variable "db_instance" {
  type    = string
  default = "db.t2.micro"
}

variable "db_name" {}

variable "db_username" {}

variable "db_password" {}

variable "aws_region" {}

variable "aws_profile" {}

variable "remote_state_bucket" {}

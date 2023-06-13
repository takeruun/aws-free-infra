variable "app_name" {}

variable "ingress_ports" {
  description = "list of ingress ports"
  default     = [80, 443]
}

variable "domain" {}

variable "aws_region" {}

variable "aws_profile" {}

variable "remote_state_bucket" {}

variable "backend_domain"{}
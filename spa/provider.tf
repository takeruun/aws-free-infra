terraform {
  backend "s3" {
    key     = "spa.tfstate"
    encrypt = true
    region  = "ap-northeast-1"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

provider "aws" {
  alias   = "virginia"
  profile = var.aws_profile
  region  = "us-east-1"
}

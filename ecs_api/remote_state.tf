data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    key     = "network.tfstate"
    profile = var.aws_profile
    bucket  = var.remote_state_bucket
    region  = var.aws_region
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    key     = "rds.tfstate"
    profile = var.aws_profile
    bucket  = var.remote_state_bucket
    region  = var.aws_region
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    key     = "alb.tfstate"
    profile = var.aws_profile
    bucket  = var.remote_state_bucket
    region  = var.aws_region
  }
}

data "terraform_remote_state" "s3_images" {
  backend = "s3"

  config = {
    key     = "s3_images.tfstate"
    profile = var.aws_profile
    bucket  = var.remote_state_bucket
    region  = var.aws_region
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    key     = "network.tfstate"
    profile = var.aws_profile
    bucket  = var.remote_state_bucket
    region  = var.aws_region
  }
}

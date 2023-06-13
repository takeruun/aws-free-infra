data "aws_caller_identity" "user" {}

data "aws_route53_zone" "this" {
  name         = var.domain
  private_zone = false
}

data "template_file" "s3_policy" {
  template = file("s3_policy.json")

  vars = {
    origin_access_identity = aws_cloudfront_origin_access_identity.this.id
    bucket_name            = local.bucket_name
    account_id             = local.account_id
  }
}

resource "aws_acm_certificate" "acm" {
  provider    = aws.virginia
  domain_name = var.domain

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm" {
  depends_on = [aws_acm_certificate.acm]

  for_each = {
    for dvo in aws_acm_certificate.acm.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.this.zone_id
  name    = each.value.name
  records = [each.value.record]
  ttl     = 60
  type    = each.value.type
}

resource "aws_acm_certificate_validation" "acm" {
  provider        = aws.virginia
  certificate_arn = aws_acm_certificate.acm.arn

  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

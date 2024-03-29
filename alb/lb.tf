resource "aws_lb" "this" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"

  security_groups = [aws_security_group.this.id]
  subnets         = data.terraform_remote_state.network.outputs.public_subnet_ids
}

resource "aws_lb_listener" "http" {
  port     = "80"
  protocol = "HTTP"

  load_balancer_arn = aws_lb.this.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  port     = "443"
  protocol = "HTTPS"

  load_balancer_arn = aws_lb.this.arn
  certificate_arn   = aws_acm_certificate.sub_acm.id

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }

  depends_on = [
    aws_acm_certificate.sub_acm
  ]
}

resource "aws_route53_record" "this" {
  type    = "A"
  name    = "${var.backend_domain}.${var.domain}"
  zone_id = data.aws_route53_zone.this.id

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

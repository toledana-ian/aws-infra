resource "aws_acm_certificate" "christiantoledana_com" {
  domain_name       = aws_route53_zone.christiantoledana_com.name
  validation_method = "DNS"
  tags              = var.default_tags
}

resource "aws_acm_certificate_validation" "christiantoledana_com" {
  certificate_arn = aws_acm_certificate.christiantoledana_com.arn
  validation_record_fqdns = [
    "${aws_route53_record.christiantoledana_com_certificate_validation.fqdn}"
  ]
}

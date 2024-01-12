resource "aws_route53_record" "ssl_christiantoledana_com" {
  name            = tolist(aws_acm_certificate.christiantoledana_com.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.christiantoledana_com.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.christiantoledana_com.id
  ttl             = 60
  allow_overwrite = true
  records         = [
    tolist(aws_acm_certificate.christiantoledana_com.domain_validation_options)[0].resource_record_value
  ]
}
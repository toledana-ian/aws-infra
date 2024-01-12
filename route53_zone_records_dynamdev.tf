resource "aws_route53_record" "dynamdev_email_blast_composer_christiantoledana_com" {
  name    = "dynamdev-email-blast-composer"
  type    = "A"
  zone_id = aws_route53_zone.christiantoledana_com.id

  alias {
    name                   = aws_cloudfront_distribution.dynamdev_email_blast_composer_christiantoledana_com.domain_name
    zone_id                = aws_cloudfront_distribution.dynamdev_email_blast_composer_christiantoledana_com.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "dynamdev_email_blast_composer_christiantoledana_com_ssl" {
  name            = tolist(aws_acm_certificate.dynamdev_email_blast_composer_christiantoledana_com.domain_validation_options)[0].resource_record_name
  type            = tolist(aws_acm_certificate.dynamdev_email_blast_composer_christiantoledana_com.domain_validation_options)[0].resource_record_type
  zone_id         = aws_route53_zone.christiantoledana_com.id
  ttl             = 60
  allow_overwrite = true
  records         = [
    tolist(aws_acm_certificate.dynamdev_email_blast_composer_christiantoledana_com.domain_validation_options)[0].resource_record_value
  ]
}
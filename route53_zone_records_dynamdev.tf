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
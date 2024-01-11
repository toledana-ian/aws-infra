#resource "aws_acm_certificate" "christiantoledana_com" {
#  domain_name       = aws_route53_zone.christiantoledana_com.name
#  validation_method = "DNS"
#  tags              = var.default_tags
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#
#resource "aws_acm_certificate_validation" "christiantoledana_com" {
#  certificate_arn = aws_acm_certificate.christiantoledana_com.arn
#  validation_record_fqdns = [
#    for record in aws_acm_certificate.christiantoledana_com.domain_validation_options : record.resource_record_name
#  ]
#}

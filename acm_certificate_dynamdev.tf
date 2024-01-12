resource "aws_acm_certificate" "dynamdev_email_blast_composer_christiantoledana_com" {
  provider = aws.acm

  domain_name = "*.${aws_route53_zone.christiantoledana_com.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.default_tags
}
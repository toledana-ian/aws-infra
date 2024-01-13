resource "aws_route53_zone" "christiantoledana_com" {
  name = "christiantoledana.com"
  tags = merge(local.default_tags, {})
}
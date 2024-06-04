resource "aws_route53_record" "app" {
  name    = var.route_app_sub_domain_name
  type    = "A"
  zone_id = var.route_zone_id

  alias {
    name                   = aws_cloudfront_distribution.app.domain_name
    zone_id                = aws_cloudfront_distribution.app.hosted_zone_id
    evaluate_target_health = false
  }
}
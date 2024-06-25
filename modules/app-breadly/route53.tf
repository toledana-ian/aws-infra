resource "aws_route53_record" "frontend" {
  name    = var.route_app_sub_domain_name_frontend
  type    = "A"
  zone_id = var.route_zone_id

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "mint_tracker" {
  name    = var.route_app_sub_domain_name_mint_tracker
  type    = "A"
  zone_id = var.route_zone_id

  alias {
    name                   = aws_cloudfront_distribution.mint_tracker.domain_name
    zone_id                = aws_cloudfront_distribution.mint_tracker.hosted_zone_id
    evaluate_target_health = false
  }
}
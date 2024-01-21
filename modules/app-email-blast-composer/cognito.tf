#resource "aws_cognito_user_pool" "app" {
#  name                     = var.name
#  username_attributes      = ["email"]
#  auto_verified_attributes = ["email"]
#
#  tags = var.tags
#}
#
#resource "aws_cognito_user_pool_client" "app" {
#  name            = var.name
#  user_pool_id    = aws_cognito_user_pool.app.id
#  generate_secret = true
#
#  explicit_auth_flows = [
#    "ALLOW_USER_SRP_AUTH",
#    "ALLOW_REFRESH_TOKEN_AUTH"
#  ]
#}
#
#resource "aws_cognito_user_pool_domain" "app" {
#  domain       = "${var.route_auth_sub_domain_name}.${var.route_domain_name}"
#  user_pool_id = aws_cognito_user_pool.app.id
#  certificate_arn = var.acm_certificate_arn
#
#
#}
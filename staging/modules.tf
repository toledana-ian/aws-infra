module "app-breadly" {
  source = "../modules/app-breadly"
  name   = "staging-breadly"
  random_suffix = "0625241035"

  enable_digest_authentication_frontend = true
  enable_digest_authentication_mint_tracker = true

  route_app_sub_domain_name_frontend = "breadly"
  route_app_sub_domain_name_mint_tracker = "mint-tracker"

  route_domain_name         = data.terraform_remote_state.global.outputs.route53_zone_name_christiantoledana_com
  route_zone_id             = data.terraform_remote_state.global.outputs.route53_zone_id_christiantoledana_com

  acm_certificate_arn = data.terraform_remote_state.global.outputs.acm_certificate_arn_christiantoledana_com

  tags = merge(local.default_tags, {
    Project = "breadly"
  })
}
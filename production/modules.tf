module "email-blast-composer" {
  source = "../modules/email-blast-composer"
  name   = "prod-email-blast-composer"

  route_sub_domain_name = "dynamdev-email-blast-composer"
  route_domain_name = data.terraform_remote_state.global.outputs.route53_zone_name_christiantoledana_com
  route_zone_id = data.terraform_remote_state.global.outputs.route53_zone_id_christiantoledana_com

  acm_certificate_arn = data.terraform_remote_state.global.outputs.acm_certificate_arn_christiantoledana_com

  tags   = local.default_tags
}
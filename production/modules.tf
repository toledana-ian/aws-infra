module "app-email-blast-composer" {
  source = "../modules/app-email-blast-composer"
  name   = "prod-email-blast-composer"

  enable_digest_authentication = true

  route_app_sub_domain_name = "dynamdev-email-blast-composer"
  route_domain_name         = data.terraform_remote_state.global.outputs.route53_zone_name_christiantoledana_com
  route_zone_id             = data.terraform_remote_state.global.outputs.route53_zone_id_christiantoledana_com

  acm_certificate_arn = data.terraform_remote_state.global.outputs.acm_certificate_arn_christiantoledana_com

  tags = merge(local.default_tags, {
    Project = "email-blast-composer"
  })
}

module "app-file-metadata-viewer" {
  source = "../modules/app-static-site-host"
  name   = "prod-file-metadata-viewer"

  enable_digest_authentication = false

  route_app_sub_domain_name = "dynamdev-file-metadata-viewer"
  route_domain_name         = data.terraform_remote_state.global.outputs.route53_zone_name_christiantoledana_com
  route_zone_id             = data.terraform_remote_state.global.outputs.route53_zone_id_christiantoledana_com

  acm_certificate_arn = data.terraform_remote_state.global.outputs.acm_certificate_arn_christiantoledana_com

  tags = merge(local.default_tags, {
    Project = "file-metadata-viewer"
  })
}

module "app-ovvie-gpt" {
  source = "../modules/app-nextjs-serverless"
  name   = "prod-ovvie-gpt"

  enable_digest_authentication = false

  route_app_sub_domain_name = "dynamdev-ovvie-gpt"
  route_domain_name         = data.terraform_remote_state.global.outputs.route53_zone_name_christiantoledana_com
  route_zone_id             = data.terraform_remote_state.global.outputs.route53_zone_id_christiantoledana_com

  acm_certificate_arn = data.terraform_remote_state.global.outputs.acm_certificate_arn_christiantoledana_com

  tags = merge(local.default_tags, {
    Project = "ovvie-gpt"
  })
}

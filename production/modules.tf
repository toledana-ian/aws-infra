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
  random_suffix = "0614241840"

  enable_digest_authentication = false

  route_app_sub_domain_name = "dynamdev-ovvie-gpt"
  route_domain_name         = data.terraform_remote_state.global.outputs.route53_zone_name_christiantoledana_com
  route_zone_id             = data.terraform_remote_state.global.outputs.route53_zone_id_christiantoledana_com

  acm_certificate_arn = data.terraform_remote_state.global.outputs.acm_certificate_arn_christiantoledana_com

  tags = merge(local.default_tags, {
    Project = "ovvie-gpt"
  })
}

module "app-ec2-public-chess-api" {
  source = "../modules/app-ec2-public"

  name           = "prod-chess-api"
  instance_type  = "t3.micro"
  vpc_id         = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id

  route_zone_id             = data.terraform_remote_state.global.outputs.route53_zone_id_christiantoledana_com
  route_domain_name         = data.terraform_remote_state.global.outputs.route53_zone_name_christiantoledana_com
  route_app_sub_domain_name = "chess-api"

  tags = merge(local.default_tags, {
    Project = "chess-api"
  })
}

module "email-blast-composer" {
  source = "../modules/email-blast-composer"
  name   = "prod-email-blast-composer"
  tags   = local.default_tags
}
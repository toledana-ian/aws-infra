resource "aws_ses_domain_identity" "christiantoledana" {
  domain = var.domain_name
}

resource "aws_ses_email_identity" "christiantoledana" {
  email = var.default_email
}
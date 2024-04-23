#if this resource failed to be created, just import it using terraform commandline:
# terraform import aws_secretsmanager_secret.sendgrid existing-secret-name-or-arn
#
#or you can force to delete it. by default it is not deleted by 7 days
# aws secretsmanager delete-secret --secret-id "secret-name-here" --force-delete-without-recovery
resource "aws_secretsmanager_secret" "sendgrid" {
  name="${var.name}-sendgrid"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "sendgrid_initial_values" {
  secret_id     = aws_secretsmanager_secret.sendgrid.id
  secret_string = jsonencode({
    API_KEY: "replace this value in AWS Secrets Manager UI"
  })
}

resource "aws_secretsmanager_secret" "digest_authentication" {
  provider = aws.us_east_1

  name="${var.name}-digest-authentication"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "digest_authentication_initial_values" {
  provider = aws.us_east_1

  secret_id     = aws_secretsmanager_secret.digest_authentication.id
  secret_string = jsonencode({
    "username": "password"
  })
}

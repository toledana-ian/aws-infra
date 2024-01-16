resource "aws_secretsmanager_secret" "sendgrid" {
  name="${var.name}-sendgrid"

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.sendgrid.id
  secret_string = jsonencode({
    API_KEY: "replace this value in AWS Secrets Manager UI"
  })
}
module "dynamdev_email_blast_webapp_s3" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "dynamdev-email-blast-webapp"
  tags   = {
    ManagedBy = "Terraform"
  }
}

module "dynamdev_email_blast_lambda_s3" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "dynamdev-email-blast-lambda"
  tags   = {
    ManagedBy = "Terraform"
  }
}
module "dynamdev_email_blast_webapp_s3" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket_name = "dynamdev-email-blast-webapp"
}

module "dynamdev_email_blast_lambda_s3" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket_name = "dynamdev-email-blast-lambda"
}
output "dynamdev_email_blast_webapp_s3_domain"{
  value = module.dynamdev_email_blast_webapp_s3.s3_bucket_bucket_domain_name
}

output "dynamdev_email_blast_lambda_s3_domain"{
  value = module.dynamdev_email_blast_lambda_s3.s3_bucket_bucket_domain_name
}
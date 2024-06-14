# Terraform Module: app-email-blast-composer

## Usage

``` terraform
module "app-email-blast-composer" {
   source = "../modules/app-email-blast-composer"
   name   = "prod-email-blast-composer"
   random_suffix = "0611242040"
   
   enable_digest_authentication = true
   
   route_app_sub_domain_name = "email-blast-composer"
   route_domain_name         = data.terraform_remote_state.global.outputs.route53_zone_name_tazlures_com
   route_zone_id             = data.terraform_remote_state.global.outputs.route53_zone_id_tazlures_com
   
   acm_certificate_arn = data.terraform_remote_state.global.outputs.acm_certificate_arn_tazlures_com
   
   tags = merge(local.default_tags, {
      Project = "email-blast-composer"
   })
}
```

## Steps to Deploy

1. **Change permission of the script**

   ```sh
   chmod +x ../modules/app-email-blast-composer/scripts/list_s3_zip_contents.sh
   ```

1. **Run Terraform Apply**

    ```sh
    terraform apply
    ```

2. **Setup SendGrid API Key in Secrets Manager**

3. **Setup Digest Authentication in CloudFront Associated KeyValueStore**
    - You can skip this step if you set the `enable_digest_authentication` to `false`.

4. **Setup Email Blast Composer GitHub Actions Secrets**
    - `AWS_ACCESS_KEY_ID`
    - `AWS_SECRET_ACCESS_KEY`

5. **Setup Email Blast Composer GitHub Actions Variables**
    - `AWS_CLOUDFRONT_DISTRIBUTION_ID`
    - `AWS_REGION`
    - `AWS_S3_BUCKET_NAME`
    - `VITE_APP_SENDER_EMAIL`

6. **Rerun Your GitHub Actions**

7. **Rerun Terraform Apply to Install Lambdas**

    ```sh
    terraform apply
    ```

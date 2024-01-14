data "external" "get_lambda_list" {
  program = ["bash", "${path.module}/scripts/list_s3_zip_contents.sh", var.name, local.lambda_zip_filename]
}
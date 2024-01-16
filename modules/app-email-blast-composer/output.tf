output "test" {
  value = data.external.get_lambda_source_code_hash.result
}
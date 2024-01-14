output "gateway_id" {
  value = var.create_igw ? aws_internet_gateway.main[0].id : null
}
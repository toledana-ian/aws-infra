resource "aws_vpc" "main" {
  cidr_block           = lookup(local.vpc_cidr_block, var.environment)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}
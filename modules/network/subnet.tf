resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = lookup(local.subnet_public_cidr_block, var.environment)
  map_public_ip_on_launch = true

  tags = var.tags
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = lookup(local.subnet_private_cidr_block, var.environment)

  tags = var.tags
}
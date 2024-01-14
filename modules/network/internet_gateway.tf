resource "aws_internet_gateway" "main" {
  count = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = var.tags
}
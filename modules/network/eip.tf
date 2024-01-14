resource "aws_eip" "main" {
  vpc = true
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id      = aws_subnet.public.id

  tags = var.tags
}
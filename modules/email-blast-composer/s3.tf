resource "aws_s3_bucket" "app" {
  bucket = var.name
  tags = var.tags
}
resource "aws_sqs_queue" "email" {
  name = "${var.name}-email-queue"
}
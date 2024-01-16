resource "aws_iam_role" "api" {
  name = "${var.name}-lambda"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "api" {
  role   = aws_iam_role.api.id
  policy = data.aws_iam_policy_document.api.json
}

data "aws_iam_policy_document" "api" {
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "queue_email" {
  name = "lambda_policy"
  role = aws_iam_role.api.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = [
        "sqs:SendMessage"
      ],
      Effect = "Allow",
      Resource = aws_sqs_queue.email.arn
    }]
  })
}
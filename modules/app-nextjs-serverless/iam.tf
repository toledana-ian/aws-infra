//########## LAMBDA ROLE ##########

resource "aws_iam_role" "lambda" {
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

resource "aws_iam_role_policy" "lambda_s3_buket_get_object" {
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.app.bucket}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_allow_logs" {
  role   = aws_iam_role.lambda.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      }
    ]
  })
}

//########## API GATEWAY ROLE ##########

resource "aws_iam_role" "api_gateway" {
  name = "${var.name}-api-gateway"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_allow_logs" {
  name   = "api_gateway_cloudwatch_policy"
  role   = aws_iam_role.api_gateway.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        Effect = "Allow",
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_group" "bot_github_action" {
  name = "bot-github-action-group"
}

resource "aws_iam_policy" "bot_github_action_s3" {
  name        = "bot-github-action-s3-policy"
  description = "IAM policy for GitHub Actions to access S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_policy" "bot_github_action_cloud_front" {
  name        = "bot-github-action-cloud-front-policy"
  description = "IAM policy for GitHub Actions to access CloudFront"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation",
        "cloudfront:GetDistribution",
        "cloudfront:ListDistributions"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_policy" "bot_github_action_lambda" {
  name        = "bot-github-action-lambda-policy"
  description = "IAM policy for GitHub Actions to access Lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "lambda:CreateFunction",
        "lambda:UpdateFunctionCode",
        "lambda:InvokeFunction"
      ],
      "Resource": "*"
    }
  ]
}
  EOF
}

resource "aws_iam_group_policy_attachment" "bot_github_action_s3" {
  group      = aws_iam_group.bot_github_action.id
  policy_arn = aws_iam_policy.bot_github_action_s3.arn
}

resource "aws_iam_group_policy_attachment" "bot_github_action_cloud_front" {
  group      = aws_iam_group.bot_github_action.id
  policy_arn = aws_iam_policy.bot_github_action_cloud_front.arn
}

resource "aws_iam_group_policy_attachment" "bot_github_action_lambda" {
  group      = aws_iam_group.bot_github_action.id
  policy_arn = aws_iam_policy.bot_github_action_lambda.arn
}
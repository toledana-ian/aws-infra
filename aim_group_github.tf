resource "aws_iam_group" "github_actions" {
  name = "GitHubActions"
}

resource "aws_iam_policy" "github_actions_s3" {
  name        = "GitHubActionsS3Policy"
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

resource "aws_iam_policy" "github_actions_cloud_front" {
  name        = "GitHubActionsCloudFrontPolicy"
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

resource "aws_iam_policy" "github_actions_lambda" {
  name        = "GitHubActionsLambdaPolicy"
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

resource "aws_iam_group_policy_attachment" "github_actions_s3" {
  group      = aws_iam_group.github_actions.id
  policy_arn = aws_iam_policy.github_actions_s3.arn
}

resource "aws_iam_group_policy_attachment" "github_actions_cloud_front" {
  group      = aws_iam_group.github_actions.id
  policy_arn = aws_iam_policy.github_actions_cloud_front.arn
}

resource "aws_iam_group_policy_attachment" "github_actions_lambda" {
  group      = aws_iam_group.github_actions.id
  policy_arn = aws_iam_policy.github_actions_lambda.arn
}
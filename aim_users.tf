resource "aws_iam_user" "github_actions" {
  name = "GithubActions"
  tags = var.default_tags
}

resource "aws_iam_user_group_membership" "github_actions" {
  user   = aws_iam_user.github_actions.id
  groups = [aws_iam_group.github_actions.id]
}
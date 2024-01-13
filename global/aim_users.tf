resource "aws_iam_user" "bot_github_action" {
  name = "bot-github-action"
}

resource "aws_iam_user_group_membership" "bot_github_action" {
  user   = aws_iam_user.bot_github_action.id
  groups = [aws_iam_group.bot_github_action.id]
}
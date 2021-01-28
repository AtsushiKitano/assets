resource "aws_iam_group" "main" {
  name = var.config.name
  path = var.config.path
}

resource "aws_iam_group_membership" "main" {
  group = aws_iam_group.main.name
  name  = var.config.membership.name

  users = var.config.membership.users
}


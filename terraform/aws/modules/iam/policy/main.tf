resource "aws_iam_group_policy" "main" {
  name   = var.config.name
  group  = var.config.group
  policy = var.config.policy
}


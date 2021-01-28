resource "aws_iam_user" "main" {
  name          = var.config.name
  path          = var.config.path
  force_destroy = var.force_destroy
  tags          = var.iam_tags
}

resource "aws_iam_access_key" "main" {
  for_each = var.config.access_key != null ? toset([var.config.name]) : toset([])

  user    = aws_iam_user.main.name
  status  = var.config.access_key.status
  pgp_key = var.key
}

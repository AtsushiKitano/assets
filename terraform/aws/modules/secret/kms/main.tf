resource "aws_kms_key" "main" {
  description              = var.description
  key_usage                = var.key_usage
  customer_master_key_spec = var.key_spec
  policy                   = var.policy
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
  tags                     = merge({ "Name" = var.config.name }, var.key_tags)
}

resource "aws_kms_grant" "main" {
  for_each = { for v in var.config.grants : v.name => v }

  name              = each.value.name
  key_id            = aws_kms_key.main.key_id
  operations        = each.value.operations
  grantee_principal = each.value.role_arn
}

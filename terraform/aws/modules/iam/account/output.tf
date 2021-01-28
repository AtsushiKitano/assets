output "encrypted_secret" {
  value = (var.config.access_key != null && var.key != null) ? aws_iam_access_key.main[var.config.name].encrypted_secret : null
}

output "key_info" {
  value = var.config.access_key != null ? aws_iam_access_key.main[var.config.name] : null
}

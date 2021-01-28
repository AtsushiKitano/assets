output "plaintext" {
  value = {
    for k, v in var.secret_datas : k => data.google_kms_secret.main[k].plaintext
  }
}

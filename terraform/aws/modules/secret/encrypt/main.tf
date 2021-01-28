resource "aws_kms_ciphertext" "main" {
  key_id = var.config.key_id

  plaintext = var.config.plaintext
}

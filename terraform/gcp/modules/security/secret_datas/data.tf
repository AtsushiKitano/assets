data "google_kms_key_ring" "main" {
  name     = var.key_infos.keyring
  location = var.key_infos.location
  project  = var.project
}

data "google_kms_crypto_key" "main" {
  name     = var.key_infos.key
  key_ring = data.google_kms_key_ring.main.self_link
}

data "google_kms_secret" "main" {
  for_each   = var.secret_datas
  crypto_key = data.google_kms_crypto_key.main.self_link
  ciphertext = each.value
}

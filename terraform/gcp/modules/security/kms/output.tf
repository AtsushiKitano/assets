output "self_link" {
  value = google_kms_key_ring.main.self_link
}

output "id" {
  value = google_kms_key_ring.main.id
}

output "key_self_link" {
  value = {
    for v in var.keys : v.name => google_kms_crypto_key.main[v.name].self_link
  }
}

output "key_id" {
  value = {
    for v in var.keys : v.name => google_kms_crypto_key.main[v.name].id
  }
}

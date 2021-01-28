resource "google_kms_key_ring" "main" {
  name     = var.key_ring.name
  location = var.key_ring.location
}

resource "google_kms_crypto_key" "main" {
  for_each = { for v in var.keys : v.name => v }

  name            = each.value.name
  key_ring        = google_kms_key_ring.main.self_link
  purpose         = var.purpose != null ? lookup(var.purpose, each.value.name, null) : null
  rotation_period = var.rotation_period != null ? lookup(var.rotation_period, each.value.name, null) : null

  dynamic "version_template" {
    for_each = var.version_template != null ? compact([lookup(var.version_template, each.value.name, "")]) : []

    content {
      algorithm        = var.algorithm != null ? lookup(var.algorithm, each.value.name, "CRYPTO_KEY_VERSION_ALGORITHM_UNSPECIFIED") : "CRYPTO_KEY_VERSION_ALGORITHM_UNSPECIFIED"
      protection_level = var.protection_level != null ? lookup(var.protection_level, each.value.name, null) : null
    }
  }
}

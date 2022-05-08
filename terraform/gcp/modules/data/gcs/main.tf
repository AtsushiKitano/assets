resource "google_storage_bucket" "main" {
  name          = var.name
  location      = var.location
  storage_class = var.storage_class
  project       = var.project
  force_destroy = var.force_destroy

  dynamic "lifecycle_rule" {
    for_each = var.enabled_lifecycle ? ["dummy"] : []

    content {
      action {
        type          = var.lifecycle.type
        storage_class = var.lifecycle.storage_class
      }
      condition {
        age                   = var.lifecycle.condition.age
        created_before        = var.lifecycle.condition.created_before
        with_state            = var.lifecycle.condition.with_state
        matches_storage_class = var.lifecycle.condition.matches_storage_class
        num_newer_versions    = var.lifecycle.condition.num_newer_versions
      }
    }
  }

  dynamic "versioning" {
    for_each = var.versioning ? ["enable"] : []

    content {
      enabled = var.versioning
    }
  }

  dynamic "website" {
    for_each = var.website != null ? [var.website] : []
    iterator = _conf

    content {
      main_page_suffix = _conf.value.main_page_suffix
      not_found_page   = _conf.value.not_found_page
    }
  }

  dynamic "cors" {
    for_each = var.cors != null ? [var.cors] : []
    iterator = _conf

    content {
      origin          = _conf.value.origin
      method          = _conf.value.method
      response_header = _conf.value.response_header
      max_age_seconds = _conf.value.max_age_seconds
    }
  }
}

resource "google_storage_bucket_object" "main" {
  for_each = { for v in var.objects : v.name => v }

  name                = each.value.name
  bucket              = google_storage_bucket.main.url
  source              = each.value.source
  cache_control       = var.cache_control != null ? lookup(var.cache_control, each.value.name, null) : null
  content_disposition = var.content_disposition != null ? lookup(var.content_disposition, each.value.name, null) : null
  content_encoding    = var.content_encoding != null ? lookup(var.content_encoding, each.value.name, null) : null
  content_language    = var.content_language != null ? lookup(var.content_language, each.value.name, null) : null
  content_type        = var.content_type != null ? lookup(var.content_type, each.value.name, null) : null
}

resource "google_storage_bucket" "main" {
  name          = var.bucket.name
  project       = var.project
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule != null ? [var.lifecycle_rule] : []
    iterator = _conf

    content {
      action {
        type          = _conf.value.type
        storage_class = _conf.value.storage_class
      }
      condition {
        age                   = _conf.value.age
        created_before        = _conf.value.created_before
        with_state            = _conf.value.with_state
        matches_storage_class = _conf.value.matches_storage_class
        num_newer_versions    = _conf.value.num_newer_versions
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

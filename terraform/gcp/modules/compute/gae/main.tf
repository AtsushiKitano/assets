resource google_app_engine_standard_app_version main {
  runtime                   = var.app_conf.runtime
  service                   = var.app_conf.service
  version_id                = var.app_conf.version_id
  delete_service_on_destroy = true

  deployment {
    dynamic "files" {
      for_each = var.app_conf.files
      iterator = _conf

      content {
        name       = _conf.value.name
        source_url = _conf.value.source_url
        sha1_sum   = _conf.value.sha1_sum
      }
    }
  }
}

resource "google_secret_manager_secret" "main" {
  secret_id = var.secret_id
  project   = var.project

  replication {
    automatic = var.automatic

    dynamic "user_managed" {
      for_each = var.user_managed != null ? ["enable"] : []

      content {
        dynamic "replicas" {
          for_each = var.user_managed.replicas
          iterator = _conf

          content {
            location = _conf.value.location
          }
        }
      }
    }
  }
}

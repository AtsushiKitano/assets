resource "google_secret_manager_secret" "main" {
  secret_id = var.secret_id
  project   = var.project

  replication {
    user_managed {
      dynamic "replicas" {
        for_each = toset(var.locations)
        iterator = _conf

        content {
          location = _conf.value
        }
      }
    }
  }
}

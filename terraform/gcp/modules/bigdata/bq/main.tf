resource "google_bigquery_dataset" "main" {
  dataset_id                      = var.dataset.dataset_id
  location                        = var.dataset.location
  default_table_expiration_ms     = var.dataset.default_table_expiration_ms
  default_partition_expiration_ms = var.default_partition_expiration_ms
  friendly_name                   = var.friendly_name
  delete_contents_on_destroy      = var.delete_contents_on_destroy
  project                         = var.project

  dynamic "access" {
    for_each = var.access
    iterator = _conf

    content {
      domain         = _conf.value.domain
      group_by_email = _conf.value.group_by_email
      role           = _conf.value.role
      special_group  = _conf.value.special_group
      user_by_email  = _conf.value.user_by_email

      dynamic "view" {
        for_each = _conf.value.view != null ? [_conf.value.view] : []
        iterator = _var

        content {
          dataset_id = _var.value.dataset_id
          project_id = _var.value.project_id
          table_id   = _var.value.table_id
        }
      }
    }
  }
}

resource "google_bigquery_table" "main" {
  for_each   = { for v in var.table : v.name => v }
  dataset_id = google_bigquery_dataset.main.dataset_id
  table_id   = each.value.name
  project    = var.project
}

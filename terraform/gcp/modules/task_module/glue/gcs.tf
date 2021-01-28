locals {
  _gcs_config = var.conf.gcs != null ? [var.conf.gcs] : []
}

resource "google_storage_bucket" "main" {
  for_each = { for v in local._gcs_config : v.name => v }

  name          = each.value.name
  location      = each.value.location
  force_destroy = lookup(each.value.opt_conf, "force_destroy", true)
}

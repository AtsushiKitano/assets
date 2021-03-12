locals {
  _static_ip = var.static_ip != null ? [var.static_ip] : []
}

resource "google_compute_global_address" "main" {
  for_each = { for v in local._static_ip : "enable" => v }

  name         = each.value.name
  address_type = each.value.type
  address      = each.value.address
  #network      = google_compute_network.main.id

  project = var.project
}

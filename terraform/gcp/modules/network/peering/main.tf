resource "google_service_networking_connection" "main" {
  network                 = var.network
  service                 = var.service
  reserved_peering_ranges = google_compute_global_address.main.*.name
}

resource "google_compute_global_address" "main" {
  for_each = { for v in var.addresses : v.name => v }

  name          = each.value.name
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  address       = split("/", each.value.address)[0]
  prefix_length = split("/", each.value.address)[1]
  network       = var.network
}

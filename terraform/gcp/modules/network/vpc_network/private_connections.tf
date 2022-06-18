locals {
  _peering_network_connections = flatten([for v in var.peering_network_connections : [
    for w in v.addresses : {
      name    = w.name
      length  = w.length
      service = v.service
    }
  ]])
}

resource "google_compute_global_address" "peering_addresses" {
  for_each = { for v in local._peering_network_connections : format("%s/%s", v.name, v.service) => v }

  name          = each.value.name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = each.value.length
  network       = google_compute_network.main.id
}

resource "google_service_networking_connection" "main" {
  for_each = { for v in var.peering_network_connections : v.service => v }

  network                 = google_compute_network.main.id
  service                 = each.value.service
  reserved_peering_ranges = [for v in each.value.addresses : google_compute_global_address.peering_addresses[format("%s/%s", v.name, each.value.service)].name]
}

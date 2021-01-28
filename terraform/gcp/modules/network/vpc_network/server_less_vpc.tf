resource "google_vpc_access_connector" "main" {
  for_each = { for v in var.serverless_vpc : v.name => v }

  name          = each.value.name
  region        = each.value.region
  ip_cidr_range = each.value.ip_cidr_range
  network       = google_compute_network.main.self_link

  min_throughput = each.value.min_throughput
  max_throughput = each.value.max_throughput
  project        = var.project
}

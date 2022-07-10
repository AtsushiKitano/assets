resource "google_compute_global_address" "main" {
  name    = var.name
  project = var.project

  network      = var.network
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  address      = var.address
}

resource "google_compute_global_forwarding_rule" "main" {
  name    = var.name
  project = var.project

  target                 = var.enable_api_type
  network                = var.network
  ip_address             = google_compute_global_address.main.id
  locad_balancing_scheme = var.lb_scheme
}

module "dns" {
  for_each = { for v in var.dnses : v.name => v }
  source   = "github.com/AtsushiKitano/assets/terraform/gcp/modules/network/dns"

  dns_name         = each.value.dns_name
  name             = each.value.name
  project          = var.project
  visibility       = "private"
  private_networks = [var.network]
  record_sets      = each.value.record_sets
}

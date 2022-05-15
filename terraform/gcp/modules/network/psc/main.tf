resource "google_compute_global_address" "main" {
  provider = google-beta

  project      = var.project
  name         = var.name
  address_type = "INTERNAL"
  purpose      = "PRIVATE_SERVICE_CONNECT"
  network      = var.network
  address      = var.address
}

resource "google_compute_global_forwarding_rule" "main" {
  provider = google-beta

  project               = var.project
  name                  = var.name
  target                = var.target
  network               = var.network
  region                = var.region
  ip_address            = google_compute_global_address.main.id
  load_balancing_scheme = var.load_balancing_scheme
}




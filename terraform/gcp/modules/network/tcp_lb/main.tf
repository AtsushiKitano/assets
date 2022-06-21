resource "google_compute_address" "main" {
  name         = var.name
  project      = var.project
  address_type = var.address_type
  subnetwork   = var.address_type == "INTERNAL" ? var.subnetwork : null
  purpose      = var.purpose
  network_tier = var.network_tier
  region       = var.region
}

resource "google_compute_backend_service" "main" {
  name     = var.name
  project  = var.project
  protocol = var.protocol

  load_balancing_scheme = var.load_balancing_scheme
  health_checks = [
    google_compute_health_check.main.id
  ]

  dynamic "backend" {
    for_each = [for v in var.backends : v]
    iterator = _conf

    content {
      group          = _conf.value.group
      balancing_mode = _conf.value.balancing_mode
    }
  }
}

resource "google_compute_health_check" "main" {
  name = var.health_check_name

  timeout_sec        = var.timeout_sec
  check_interval_sec = var.check_interval_sec
  project            = var.project

  tcp_health_check {
    port = var.port
  }
}

resource "google_compute_target_tcp_proxy" "main" {
  name            = var.name
  backend_service = google_compute_backend_service.main.id
  project         = var.project
}

resource "google_compute_forwarding_rule" "main" {
  name                  = var.name
  target                = google_compute_target_tcp_proxy.main.id
  ip_address            = google_compute_address.main.id
  network               = var.load_balancing_scheme == "INTERNAL" ? var.network : null
  network_tier          = var.network_tier
  ip_protocol           = var.protocol
  region                = var.region
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.port_range
  project               = var.project
}

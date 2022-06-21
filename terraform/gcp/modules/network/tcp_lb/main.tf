resource "google_compute_address" "main" {
  name         = var.name
  project      = var.project
  address_type = var.address_type
  purpose      = "SHARED_LOADBALANCER_VIP"
  network_tier = var.network_tier
  region       = var.address_region
}

resource "google_compute_region_backend_service" "main" {
  name     = var.name
  project  = var.project
  region   = var.region
  network  = var.network
  protocol = var.protocol

  load_balancing_scheme = var.load_balancing_scheme
  health_checks = [
    google_compute_region_health_check.main.id
  ]

  dynamic "backend" {
    for_each = [for v in var.backends : v]
    iterator = _conf

    content {
      group          = _conf.value.group
      failover       = _conf.value.failover
      balancing_mode = _conf.value.balancing_mode
    }
  }
}

resource "google_compute_region_health_check" "main" {
  name = var.helth_check_name

  timeout_sec        = var.timeout_sec
  check_interval_sec = var.check_interval_sec
  project            = var.project
  region             = var.region

  tcp_health_check {
    port = var.port
  }
}

resource "google_compute_target_tcp_proxy" "main" {
  name            = var.name
  backend_service = google_compute_region_backend_service.main.id
  project         = var.project
}

resource "google_compute_forwarding_rule" "main" {
  name                  = var.name
  ip_address            = google_compute_address.main.id
  network               = var.network
  network_tier          = var.network_tier
  ip_protocol           = var.protocol
  region                = var.region
  load_balancing_scheme = var.load_balancing_scheme
  port_range            = var.port_range
}

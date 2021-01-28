locals {
  lb_scheme = "INTERNAL"
}

resource "google_compute_region_backend_service" "main" {
  name                  = var.backend_service.name
  locality_lb_policy    = var.backend_service.lb_policy
  session_affinity      = var.backend_service.session_affinity
  timeout_sec           = var.backend_service.timeout_sec
  protocol              = var.backend_service.protocol
  health_checks         = var.backend_service.health_checks
  load_balancing_scheme = local.lb_scheme

  dynamic "backend" {
    for_each = var.backend_service.backend != null ? [var.backend_service.backend] : []
    iterator = _conf

    content {
      group                        = _conf.value.group
      balancing_mode               = var._conf.value.balancing_mode
      max_connections              = _conf.value.max_connections
      max_connections_per_instance = _conf.value.max_connections_per_instance
      max_connections_per_endpoint = _conf.value.max_connections_per_endpoint
      max_rate                     = _conf.value.max_rate
      max_rate_per_instance        = _conf.value.max_rate_per_instance
      max_rate_per_endpoint        = _conf.value.max_rate_per_endpoint
      max_utilization              = _conf.value.max_utilization
    }
  }
}

resource "google_compute_address" "main" {
  name         = var.ip_address.name
  address_type = "INTERNAL"
  address      = var.ip_address.address
  purpose      = var.ip_address_purpose
  region       = var.region
  subnetwork   = var.forwarding_rule.subnetwork
}

resource "google_compute_forwarding_rule" "main" {
  name                  = var.forwarding_rule.name
  ip_protocol           = var.forwarding_rule.protocol
  backend_service       = google_compute_region_backend_service.main.id
  load_balancing_scheme = local.lb_scheme
  network               = var.forwarding_rule.network
  subnetwork            = var.forwarding_rule.subnetwork
  ip_address            = google_compute_address.main.address
  port_range            = var.forwarding_rule.port_range
  ports                 = var.forwarding_rule.ports
  all_ports             = var.forwarding_rule.all_ports
  network_tier          = var.network_tier
  service_label         = var.forwarding_rule.service_label
  allow_global_access   = var.forwarding_rule.allow_global_access
  region                = var.region
  project               = var.project
}

resource "google_compute_router" "main" {
  name        = format("%s-nat", var.name)
  network     = var.network
  description = var.router_description
  project     = var.project
  region      = var.region

  dynamic "bgp" {
    for_each = var.bgp != null ? [var.bgp] : []
    iterator = _config

    content {
      asn               = _config.value.asn
      advertise_mode    = _config.value.advertise_mode
      advertised_groups = _config.value.advertise_mode == "CUSTOM" ? _config.value.advertised_groups : null

      dynamic "advertised_ip_ranges" {
        for_each = _config.value.advertise_mode == "CUSTOM" ? _config.value.advertised_ip_ranges : []
        iterator = _var

        content {
          range = _var.value
        }
      }
    }
  }
}

resource "google_compute_address" "main" {
  count = var.nat_address_redundancy

  name         = format("%s-nat-%s", var.name, count.index)
  region       = google_compute_router.main.region
  address_type = "EXTERNAL"
  project      = var.project
}

resource "google_compute_router_nat" "main" {
  for_each = { for v in var.nat_gws : v.name => v }

  name                               = each.value.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = each.value.source_subnetwork_ip_ranges_to_nat
  router                             = google_compute_router.main.name
  region                             = google_compute_router.main.region
  nat_ips                            = google_compute_address.main.*.self_link
  project                            = var.project
  min_ports_per_vm                   = each.value.min_ports_per_vm
  tcp_established_idle_timeout_sec   = each.value.protocol_config != null ? each.value.protocol_config.tcp_established_idle_timeout_sec : null
  tcp_transitory_idle_timeout_sec    = each.value.protocol_config != null ? each.value.protocol_config.tcp_transitory_idle_timeout_sec : null
  udp_idle_timeout_sec               = each.value.protocol_config != null ? each.value.protocol_config.udp_idle_timeout_sec : null
  icmp_idle_timeout_sec              = each.value.protocol_config != null ? each.value.protocol_config.icmp_idle_timeout_sec : null

  dynamic "subnetwork" {
    for_each = each.value.source_subnetwork_ip_ranges_to_nat == "LIST_OF_SUBNETWORKS" ? each.value.source_subnetworks : []
    iterator = _config

    content {
      name                    = _config.value.name
      source_ip_ranges_to_nat = _config.value.source_ip_ranges_to_nat
    }
  }

  dynamic "log_config" {
    for_each = each.value.log_config_filter != null ? [each.value.log_config_filter] : []
    iterator = _config

    content {
      enable = true
      filter = _config.value
    }
  }
}

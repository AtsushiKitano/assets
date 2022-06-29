resource "google_compute_network" "main" {
  name                    = var.name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.vpc_network_routing

  mtu                             = var.vpc_network_mtu
  project                         = var.project
  delete_default_routes_on_create = var.delete_default_routes
}

resource "google_compute_subnetwork" "main" {
  for_each = { for v in var.subnetworks : v.name => v }
  provider = google-beta

  name          = each.value.name
  ip_cidr_range = each.value.cidr
  network       = google_compute_network.main.self_link
  region        = each.value.region
  role          = each.value.role

  # option config
  project                  = var.project
  private_ip_google_access = each.value.private_ip_google_access
  purpose                  = each.value.purpose

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges
    iterator = _conf

    content {
      range_name    = _conf.value.range_name
      ip_cidr_range = _conf.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = var.subnet_log_config != null ? lookup(var.subnet_log_config, each.value.name, []) : []
    iterator = _conf

    content {
      aggregation_interval = _conf.value.aggregation_interval
      flow_sampling        = _conf.value.flow_sampling
      metadata             = _conf.value.metadata
      filter_expr          = _conf.value.filter_expr
    }
  }
}

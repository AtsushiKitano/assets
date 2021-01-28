resource "google_compute_network" "main" {
  name                    = var.vpc_network.name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.vpc_network_routing

  mtu                             = var.vpc_network_mtu
  project                         = var.project
  delete_default_routes_on_create = var.vpc_network_delete_default_routes_on_create
}

resource "google_compute_subnetwork" "main" {
  for_each = { for v in var.subnetworks : v.name => v }
  provider = google-beta

  name          = each.value.name
  ip_cidr_range = each.value.cidr
  network       = google_compute_network.main.self_link
  region        = each.value.region


  # option config
  project                  = var.project
  private_ip_google_access = var.subnet_private_google_access
  purpose                  = var.subnet_purpose != null ? lookup(var.subnet_purpose, each.value.name, null) : null


  dynamic "secondary_ip_range" {
    for_each = var.subnet_secondary_ip_range != null ? lookup(var.subnet_secondary_ip_range, each.value.name, []) : []
    iterator = _conf

    content {
      range_name    = _conf.value.range_name
      ip_cidr_range = _conf.value.ip_cidr_rang
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

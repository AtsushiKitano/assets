resource "google_compute_firewall" "main" {
  for_each = { for v in var.firewall : v.name => v }

  name        = each.value.name
  network     = google_compute_network.main.self_link
  project     = var.project
  priority    = each.value.priority
  target_tags = each.value.tags
  disabled    = var.fw_disabled != null ? lookup(var.fw_disabled, each.value.name, null) : null

  direction          = each.value.direction
  source_ranges      = each.value.direction == "INGRESS" ? each.value.ranges : null
  destination_ranges = each.value.direction == "EGRESS" ? each.value.ranges : null

  dynamic "allow" {
    for_each = flatten([
      for v in each.value.rules : v.type == "allow" ? [v] : []
    ])
    iterator = _conf

    content {
      protocol = _conf.value.protocol
      ports    = _conf.value.ports
    }
  }

  dynamic "deny" {
    for_each = flatten([
      for v in each.value.rules : v.type == "deny" ? [v] : []
    ])
    iterator = _conf

    content {
      protocol = _conf.value.protocol
      ports    = _conf.value.ports
    }
  }


  dynamic "log_config" {
    for_each = each.value.log_config_metadata != null ? [each.value.log_config_metadata] : []
    iterator = _conf

    content {
      metadata = _conf.value
    }
  }
}

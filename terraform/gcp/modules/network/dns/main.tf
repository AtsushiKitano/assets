resource "google_dns_managed_zone" "main" {
  dns_name      = var.zone.dns_name
  name          = var.zone.name
  description   = var.zone_discreption
  visibility    = var.zone.visibility
  project       = var.project
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = var.zone.visibility == "private" && var.private_visibility != null ? ["enable"] : []

    content {
      dynamic "networks" {
        for_each = var.private_visibility.networks
        iterator = _conf

        content {
          network_url = _conf.value
        }
      }
    }
  }

  dynamic "dnssec_config" {
    for_each = var.dnssec != null ? [var.dnssec] : []
    iterator = _conf

    content {
      kind          = _conf.value.kind
      non_existence = _conf.value.non_existence
      state         = _conf.value.state

      dynamic "default_key_specs" {
        for_each = _conf.value.key_specs != null ? [_conf.value.key_specs] : []
        iterator = _var

        content {
          algorithm  = _var.value.algorithm
          key_length = _var.value.key_length
          key_type   = _var.value.key_type
          kind       = _var.value.kind
        }
      }
    }
  }

  dynamic "forwarding_config" {
    for_each = var.forwarding != null ? ["enable"] : []

    content {
      dynamic "target_name_servers" {
        for_each = var.forwarding.target_servers
        iterator = _conf

        content {
          ipv4_address    = _conf.value.ip_address
          forwarding_path = _conf.value.path
        }
      }
    }
  }

  dynamic "peering_config" {
    for_each = var.peering != null ? ["enable"] : []

    content {
      dynamic "target_network" {
        for_each = var.peering.networks
        iterator = _conf

        content {
          network_url = _conf.value
        }
      }
    }
  }
}

resource "google_dns_record_set" "main" {
  for_each = { for v in var.records : join("_", [replace(v.name, ".", "_"), v.type, v.ttl]) => v }

  managed_zone = google_dns_managed_zone.main.name
  name         = each.value.name
  rrdatas      = each.value.rrdatas
  ttl          = each.value.ttl
  type         = each.value.type
  project      = var.project
}

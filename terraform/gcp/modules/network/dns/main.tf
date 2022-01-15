resource "google_dns_managed_zone" "main" {
  dns_name    = var.dns_name
  name        = var.name
  description = var.description
  visibility  = var.visibility
  project     = var.project

  dynamic "private_visibility_config" {
    for_each = var.visibility == "private" ? toset(["dummy"]) : []

    content {
      dynamic "networks" {
        for_each = toset([var.private_networks])
        iterator = _config

        content {
          network_url = _config.value
        }
      }
    }
  }

  dynamic "dnssec_config" {
    for_each = var.dnssec_config != null ? toset(["dummy"]) : []

    content {
      kind          = var.dnssec_config.kind
      non_existence = var.dnssec_config.non_existence
      state         = var.dnssec_config.state

      dynamic "default_key_specs" {
        for_each = var.default_key_specs != null ? toset(["dummy"]) : []

        content {
          algorithm  = var.default_key_specs.algorithm
          key_length = var.default_key_specs.key_length
          key_type   = var.default_key_specs.key_type
          kind       = var.default_key_specs.kind
        }
      }
    }
  }

  dynamic "forwarding_config" {
    for_each = var.target_name_servers != null ? toset(["dummy"]) : []

    content {
      dynamic "target_name_servers" {
        for_each = var.target_name_servers
        iterator = _config

        content {
          ipv4_address    = _config.value.ipv4_address
          forwarding_path = _config.value.forwarding_path
        }
      }
    }
  }

  dynamic "peering_config" {
    for_each = length(var.peering_target_network) > 0 ? toset(["dummy"]) : []

    content {
      dynamic "target_network" {
        for_each = var.peering_target_network
        iterator = _config

        content {
          netwok_url = _config.value
        }
      }
    }
  }
}


resource "google_dns_record_set" "main" {
  count = length(var.record_sets)

  managed_zone = google_dns_managed_zone.main.name
  name         = join(".", [var.record_sets[content.index].name, google_dns_managed_zone.main.dns_name])
  rrdatas      = var.record_sets[content.index].rrdatas
  ttl          = var.record_sets[content.index].ttl
  type         = var.record_sets[content.index].type
  project      = var.project
}

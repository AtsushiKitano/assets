resource "google_dns_policy" "main" {
  name                      = var.name
  enable_inbound_forwarding = var.enable_inbound_forwarding

  enable_logging = var.enable_logging

  dynamic "alternative_name_server_config" {
    for_each = length(var.target_name_servers) > 0 ? toset(["dummy"]) : []

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

  dynamic "networks" {
    for_each = var.networks
    iterator = _config

    content {
      network_url = _config.value
    }
  }
}

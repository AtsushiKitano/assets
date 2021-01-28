locals {
  networks = [
    {
      name         = var.peering.main_name
      network      = var.peering.network[0]
      peer_network = var.peering.network[1]
    },
    {
      name         = var.peering.sub_name
      network      = var.peering.network[1]
      peer_network = var.peering.network[0]
    },
  ]
}

resource "google_compute_network_peering" "main" {
  for_each = { for v in local.networks : v.name => v }

  name                                = each.value.name
  network                             = each.value.network
  peer_network                        = each.value.peer_network
  export_custom_routes                = var.export_custom_routes != null ? lookup(var.export_custom_routes, each.value.network, false) : false
  import_custom_routes                = var.import_custom_routes != null ? lookup(var.import_custom_routes, each.value.network, false) : false
  export_subnet_routes_with_public_ip = var.export_subnet_routes_with_public_ip != null ? lookup(var.export_subnet_routes_with_public_ip, each.value.network, true) : true
  import_subnet_routes_with_public_ip = var.import_subnet_routes_with_public_ip != null ? lookup(var.import_subnet_routes_with_public_ip, each.value.network, false) : false
}

resource "google_compute_ha_vpn_gateway" "main" {
  provider = google-beta

  name    = var.gateway.name
  region  = var.region
  network = var.network
}

resource "google_compute_router" "main" {
  provider = google-beta

  name    = var.router.name
  network = var.network
  region  = var.region

  bgp {
    asn = var.router.bgp_asn
  }
}

resource "google_compute_vpn_tunnel" "main" {
  provider = google-beta
  for_each = { for v in var.vpn_tunnel : v.name => v }

  name                  = each.value.name
  region                = var.region
  vpn_gateway           = google_compute_ha_vpn_gateway.main.self_link
  peer_gcp_gateway      = each.value.peer_gcp_gateway
  shared_secret         = each.value.vpn_tunnel.shared_secret
  router                = google_compute_router.main.self_link
  vpn_gateway_interface = each.value.vpn_gateway_interface
}

resource "google_compute_router_interface" "main" {
  for_each = { for v in var.router_ifs : v.name => v }

  name       = each.value.name
  router     = google_compute_router.main.name
  region     = var.region
  ip_range   = each.value.ip_range
  vpn_tunnel = google_compute_vpn_tunnel.main[each.value.vpn_tunnel].self_link
}

resource "google_compute_router_peer" "main" {
  for_each = { for v in var.router_peers : v.name => v }

  name                      = each.value.name
  router                    = google_compute_router.main.name
  region                    = var.region
  peer_asn                  = each.value.peer_asn
  interface                 = google_compute_router_interface.main[each.value.interface].name
  peer_ip_address           = each.value.peer_ip_address
  advertised_route_priority = each.value.advertised_route_priority
}


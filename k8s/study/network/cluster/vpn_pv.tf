resource "google_compute_ha_vpn_gateway" "private_ha_gw" {
  provider = google-beta
  region   = "asia-northeast1"
  name     = "private-ha-vpn1"
  network  = google_compute_network.private.self_link
}

resource "google_compute_router" "private_router" {
  provider = google-beta
  name     = "private-router"
  network  = google_compute_network.private.name
  bgp {
    asn = 64515
  }
}

resource "google_compute_vpn_tunnel" "private-tunnel1" {
  provider              = google-beta
  name                  = "private-ha-vpn-tunnel1"
  region                = "asia-northeast1"
  vpn_gateway           = google_compute_ha_vpn_gateway.private_ha_gw.self_link
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.gke_ha_gw.self_link
  shared_secret         = "LnXOSA7mG5ukKkAitxVtA8eoEVUqporU"
  router                = google_compute_router.private_router.self_link
  vpn_gateway_interface = 0
}

resource "google_compute_router_interface" "private-router-if1" {
  provider   = google-beta
  name       = "privaterouter-if1"
  router     = google_compute_router.private_router.name
  region     = "asia-northeast1"
  ip_range   = "169.254.0.2/30"
  vpn_tunnel = google_compute_vpn_tunnel.private-tunnel1.name
}

resource "google_compute_router_peer" "privaterouter_peer1" {
  provider                  = google-beta
  name                      = "privaterouter-peer1"
  router                    = google_compute_router.private_router.name
  region                    = "asia-northeast1"
  peer_ip_address           = "169.254.0.1"
  peer_asn                  = 64516
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.private-router-if1.name
}

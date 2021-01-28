resource "google_compute_ha_vpn_gateway" "gke_ha_gw" {
  provider = google-beta
  region   = "asia-northeast1"
  name     = "gke-ha-vpn1"
  network  = google_compute_network.gke.self_link
}

resource "google_compute_router" "gke_router" {
  provider = google-beta
  name     = "gke-router"
  network  = google_compute_network.gke.name
  bgp {
    asn = 64516
  }
}

resource "google_compute_vpn_tunnel" "gke-tunnel1" {
  provider              = google-beta
  name                  = "gke-ha-vpn-tunnel1"
  region                = "asia-northeast1"
  vpn_gateway           = google_compute_ha_vpn_gateway.gke_ha_gw.self_link
  peer_gcp_gateway      = google_compute_ha_vpn_gateway.private_ha_gw.self_link
  shared_secret         = "LnXOSA7mG5ukKkAitxVtA8eoEVUqporU"
  router                = google_compute_router.gke_router.self_link
  vpn_gateway_interface = 0
}

resource "google_compute_router_interface" "gke-router-if1" {
  provider   = google-beta
  name       = "gke-router-if1"
  router     = google_compute_router.gke_router.name
  region     = "asia-northeast1"
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.gke-tunnel1.name
}

resource "google_compute_router_peer" "gke_router_peer1" {
  provider                  = google-beta
  name                      = "gke-router-peer1"
  router                    = google_compute_router.gke_router.name
  region                    = "asia-northeast1"
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.gke-router-if1.name
}

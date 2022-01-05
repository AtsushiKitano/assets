locals {
  ipsec_type = {
    "ipsec.1" = 1
  }
}

/*
AWS VPN Resource
*/

resource "aws_customer_gateway" "main" {
  bgp_asn    = var.aws_vpn.bgp_asn
  ip_address = google_compute_ha_vpn_gateway.main.vpn_interfaces[0].ip_address
  type       = var.ipsec_type

  tags = {
    Name = var.aws_vpn.name
  }
}

resource "aws_vpn_connection" "main" {
  customer_gateway_id = aws_customer_gateway.main.id
  type                = aws_customer_gateway.main.type
  vpn_gateway_id      = aws_vpn_gateway.main.id

  tags = {
    Name = var.aws_vpn.name
  }
}

resource "aws_vpn_gateway_route_propagation" "main" {
  vpn_gateway_id = aws_vpn_gateway.main.id
  route_table_id = var.aws_vpn.route_table_id

  tags = {
    Name = var.aws_vpn.name
  }
}

/*
GCP VPN Resource
*/

resource "google_compute_ha_vpn_gateway" "main" {
  name    = var.gcp_vpn.name
  region  = var.region
  network = var.gcp_vpn.network
  project = var.project
}

resource "google_compute_router" "main" {
  name    = var.gcp_vpn.name
  region  = var.region
  network = var.gcp_vpn.network
  project = var.project
  bgp {
    asn = var.gcp_vpn.asn
  }
}

resource "google_compute_external_vpn_gateway" "main" {
  name            = var.gcp_vpn.ex_vpn_gw_name
  project         = var.project
  redundancy_type = "TWO_IPS_REDUNDANCY"

  interface {
    id         = 0
    ip_address = aws_vpn_connection.main.tunnel1_address
  }

  interface {
    id         = 1
    ip_address = aws_vpn_connection.main.tunnel2_address
  }
}

/*
GCP main tunnel
*/

resource "google_compute_vpn_tunnel" "main" {
  name                            = var.gcp_vpn.main_tunnel_name
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  shared_secret                   = aws_vpn_connection.main.tunnel1_preshared_key
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.main.self_link
  peer_external_gateway_interface = 0
  router                          = google_compute_router.main.name
  ike_version                     = local.ipsec_type[var.ipsec_type]
}

resource "google_compute_router_interface" "main" {
  name       = var.gcp_vpn.main_tunnel_name
  project    = var.project
  region     = var.region
  router     = google_compute_router.main.name
  ip_range   = format("%s/30", aws_vpn_connection.main.tunnel1_cgw_inside_address)
  vpn_tunnel = google_compute_vpn_tunnel.main.name
}

resource "google_compute_router_peer" "main" {
  name            = google_compute_vpn_tunnel.main.name
  project         = var.project
  region          = var.region
  router          = google_compute_router.main.name
  peer_ip_address = aws_vpn_connection.main.tunnel1_vgw_inside_address
  peer_asn        = aws_vpn_connection.main.tunnel1_bgp_asn
  interface       = google_compute_router_interface.main.name
}


/*
GCP sub tunnel
*/

resource "google_compute_vpn_tunnel" "sub" {
  name                            = var.gcp_vpn.sub_tunnel_name
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  shared_secret                   = aws_vpn_connection.main.tunnel1_preshared_key
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.main.self_link
  peer_external_gateway_interface = 1
  router                          = google_compute_router.main.name
  ike_version                     = local.ipsec_type[var.ipsec_type]
}

resource "google_compute_router_interface" "sub" {
  name       = var.gcp_vpn.sub_tunnel_name
  project    = var.project
  region     = var.region
  router     = google_compute_router.main.name
  ip_range   = format("%s/30", aws_vpn_connection.main.tunnel1_cgw_inside_address)
  vpn_tunnel = google_compute_vpn_tunnel.sub.name
}

resource "google_compute_router_peer" "sub" {
  name            = google_compute_vpn_tunnel.sub.name
  project         = var.project
  region          = var.region
  router          = google_compute_router.main.name
  peer_ip_address = aws_vpn_connection.main.tunnel1_vgw_inside_address
  peer_asn        = aws_vpn_connection.main.tunnel1_bgp_asn
  interface       = google_compute_router_interface.sub.name
}

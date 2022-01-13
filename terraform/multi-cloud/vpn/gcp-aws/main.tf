locals {
  ipsec_type = {
    "ipsec.1" = 1
  }

  redundancy_type = {
    1 = "TWO_IPS_REDUNDANCY"
    2 = "FOUR_IPS_REDUNDANCY"
  }
}

/*
AWS VPN Resource
*/

resource "aws_vpn_gateway" "main" {
  vpc_id = var.aws_vpn.vpc_id

  tags = {
    Name = var.aws_vpn.name
  }
}

resource "aws_customer_gateway" "main" {
  bgp_asn    = var.aws_vpn.bgp_asn
  ip_address = google_compute_ha_vpn_gateway.main.vpn_interfaces[0].ip_address
  type       = var.ipsec_type

  tags = {
    Name = format("%s-main", var.aws_vpn.name)
  }
}

resource "aws_vpn_connection" "main" {
  customer_gateway_id = aws_customer_gateway.main.id
  type                = aws_customer_gateway.main.type
  vpn_gateway_id      = aws_vpn_gateway.main.id

  tags = {
    Name = format("%s-main", var.aws_vpn.name)
  }
}

resource "aws_customer_gateway" "sub" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  bgp_asn    = var.aws_vpn.bgp_asn + 100
  ip_address = google_compute_ha_vpn_gateway.main.vpn_interfaces[1].ip_address
  type       = var.ipsec_type

  tags = {
    Name = format("%s-sub", var.aws_vpn.name)
  }
}

resource "aws_vpn_connection" "sub" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  customer_gateway_id = aws_customer_gateway.sub["enable"].id
  type                = aws_customer_gateway.sub["enable"].type
  vpn_gateway_id      = aws_vpn_gateway.main.id

  tags = {
    Name = format("%s-sub", var.aws_vpn.name)
  }
}


resource "aws_vpn_gateway_route_propagation" "main" {
  vpn_gateway_id = aws_vpn_gateway.main.id
  route_table_id = var.aws_vpn.route_table_id
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
  redundancy_type = local.redundancy_type[var.redundancy]

  interface {
    id         = 0
    ip_address = aws_vpn_connection.main.tunnel1_address
  }

  interface {
    id         = 1
    ip_address = aws_vpn_connection.main.tunnel2_address
  }

  dynamic "interface" {
    for_each = var.redundancy == 2 ? toset(["dummy"]) : []

    content {
      id         = 2
      ip_address = aws_vpn_connection.sub.tunnel1_address
    }
  }

  dynamic "interface" {
    for_each = var.redundancy == 2 ? toset(["dummy"]) : []

    content {
      id         = 3
      ip_address = aws_vpn_connection.sub.tunnel2_address
    }
  }
}

/*
GCP main1 tunnel
*/

resource "google_compute_vpn_tunnel" "main1" {
  name                            = format("%s-1", var.gcp_vpn.main_tunnel_name)
  region                          = var.region
  project                         = var.project
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  shared_secret                   = aws_vpn_connection.main.tunnel1_preshared_key
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.main.self_link
  peer_external_gateway_interface = 0
  router                          = google_compute_router.main.name
  ike_version                     = local.ipsec_type[var.ipsec_type]
}

resource "google_compute_router_interface" "main1" {
  name       = format("%s-1", var.gcp_vpn.main_tunnel_name)
  project    = var.project
  region     = var.region
  router     = google_compute_router.main.name
  ip_range   = format("%s/30", aws_vpn_connection.main.tunnel1_cgw_inside_address)
  vpn_tunnel = google_compute_vpn_tunnel.main1.name
}

resource "google_compute_router_peer" "main1" {
  name            = google_compute_vpn_tunnel.main1.name
  project         = var.project
  region          = var.region
  router          = google_compute_router.main.name
  peer_ip_address = aws_vpn_connection.main.tunnel1_vgw_inside_address
  peer_asn        = aws_vpn_connection.main.tunnel1_bgp_asn
  interface       = google_compute_router_interface.main1.name
}

/*
GCP sub1 tunnel
*/

resource "google_compute_vpn_tunnel" "sub1" {
  name                            = format("%s-1", var.gcp_vpn.sub_tunnel_name)
  region                          = var.region
  project                         = var.project
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  shared_secret                   = aws_vpn_connection.main.tunnel2_preshared_key
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.main.self_link
  peer_external_gateway_interface = 1
  router                          = google_compute_router.main.name
  ike_version                     = local.ipsec_type[var.ipsec_type]
}

resource "google_compute_router_interface" "sub1" {
  name       = format("%s-1", var.gcp_vpn.sub_tunnel_name)
  project    = var.project
  region     = var.region
  router     = google_compute_router.main.name
  ip_range   = format("%s/30", aws_vpn_connection.main.tunnel2_cgw_inside_address)
  vpn_tunnel = google_compute_vpn_tunnel.sub1.name
}

resource "google_compute_router_peer" "sub1" {
  name            = google_compute_vpn_tunnel.sub1.name
  project         = var.project
  region          = var.region
  router          = google_compute_router.main.name
  peer_ip_address = aws_vpn_connection.main.tunnel2_vgw_inside_address
  peer_asn        = aws_vpn_connection.main.tunnel2_bgp_asn
  interface       = google_compute_router_interface.sub1.name
}


/*
GCP main2 tunnel
*/

resource "google_compute_vpn_tunnel" "main2" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  name                            = format("%s-2", var.gcp_vpn.main_tunnel_name)
  region                          = var.region
  project                         = var.project
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  shared_secret                   = aws_vpn_connection.main.tunnel1_preshared_key
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.main.self_link
  peer_external_gateway_interface = 0
  router                          = google_compute_router.main.name
  ike_version                     = local.ipsec_type[var.ipsec_type]
}

resource "google_compute_router_interface" "main2" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  name       = format("%s-2", var.gcp_vpn.main_tunnel_name)
  project    = var.project
  region     = var.region
  router     = google_compute_router.main.name
  ip_range   = format("%s/30", aws_vpn_connection.sub["enable"].tunnel1_cgw_inside_address)
  vpn_tunnel = google_compute_vpn_tunnel.main2["enable"].name
}

resource "google_compute_router_peer" "main2" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  name            = google_compute_vpn_tunnel.main2["enable"].name
  project         = var.project
  region          = var.region
  router          = google_compute_router.main.name
  peer_ip_address = aws_vpn_connection.sub["enable"].tunnel1_vgw_inside_address
  peer_asn        = aws_vpn_connection.sub["enable"].tunnel1_bgp_asn
  interface       = google_compute_router_interface.main2["enable"].name
}


/*
GCP sub2 tunnel
*/

resource "google_compute_vpn_tunnel" "sub2" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  name                            = format("%s-2", var.gcp_vpn.sub_tunnel_name)
  region                          = var.region
  project                         = var.project
  vpn_gateway                     = google_compute_ha_vpn_gateway.main.id
  shared_secret                   = aws_vpn_connection.sub["enable"].tunnel2_preshared_key
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.main.self_link
  peer_external_gateway_interface = 1
  router                          = google_compute_router.main.name
  ike_version                     = local.ipsec_type[var.ipsec_type]
}

resource "google_compute_router_interface" "sub2" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  name       = format("%s-2", var.gcp_vpn.sub_tunnel_name)
  project    = var.project
  region     = var.region
  router     = google_compute_router.main.name
  ip_range   = format("%s/30", aws_vpn_connection.sub["enable"].tunnel2_cgw_inside_address)
  vpn_tunnel = google_compute_vpn_tunnel.sub2["enable"].name
}

resource "google_compute_router_peer" "sub2" {
  for_each = var.redundancy == 2 ? toset(["enable"]) : []

  name            = google_compute_vpn_tunnel.sub2["enable"].name
  project         = var.project
  region          = var.region
  router          = google_compute_router.main.name
  peer_ip_address = aws_vpn_connection.sub["enable"].tunnel2_vgw_inside_address
  peer_asn        = aws_vpn_connection.sub["enable"].tunnel2_bgp_asn
  interface       = google_compute_router_interface.sub2["enable"].name
}

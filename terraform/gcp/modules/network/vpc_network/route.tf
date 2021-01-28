resource "google_compute_route" "main" {
  for_each = { for v in var.route : v.name => v }

  name                   = each.value.name
  dest_range             = each.value.dest_range
  network                = google_compute_network.main.self_link
  priority               = each.value.priority
  tags                   = each.value.tags
  next_hop_gateway       = each.value.next_hop_gateway
  next_hop_instance      = var.route_next_hop_gce != null ? lookup(var.route_next_hop_gce, each.value.name, null) : null
  next_hop_vpn_tunnel    = var.route_next_hop_vpn_tunnel != null ? lookup(var.route_next_hop_vpn_tunnel, each.value.name, null) : null
  next_hop_ip            = var.route_next_hop_ip != null ? lookup(var.route_next_hop_ip, each.value.name, null) : null
  next_hop_ilb           = var.route_next_hop_ilb != null ? lookup(var.route_next_hop_ilb, each.value.name, null) : null
  next_hop_instance_zone = var.route_next_hop_instance_zone != null ? lookup(var.route_next_hop_instance_zone, each.value.name, null) : null
}

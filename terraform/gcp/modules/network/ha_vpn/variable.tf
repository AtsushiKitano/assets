variable "network" {
  type = string
}

variable "region" {
  type = string
}

variable "gateway" {
  type = object({
    name = string
  })
}

variable "vpn_tunnel" {
  type = list(object({
    name                  = string
    peer_gcp_gateway      = string
    shared_secret         = string
    vpn_gateway_interface = string
  }))
}

variable "router_ifs" {
  type = list(object({
    name       = string
    ip_range   = string
    vpn_tunnel = string
  }))
}

variable "router_peers" {
  type = list(object({
    name                      = string
    peer_asn                  = string
    interface                 = string
    peer_ip_address           = string
    advertised_route_priority = string
  }))
}

variable "router" {
  type = object({
    name    = string
    bgp_asn = number
  })
}

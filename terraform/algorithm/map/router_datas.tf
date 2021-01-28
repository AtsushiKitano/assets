locals {
  _router_interface_list = flatten([
    for _router_conf in var.router_conf : [
      for _if_conf in _router_conf.interface : {
        name       = _if_conf.interface_name
        ip_range   = _if_conf.ip_range
        vpn_tunnel = _if_conf.vpn_tunnel
        region     = _router_conf.region
        router     = _router_conf.router_name
      }
    ]
  ])

  _router_peer_list = flatten([
    for _router_conf in var.router_conf : [
      for _peer_conf in _router_conf.peer : {
        name                      = _peer_conf.peer_name
        router                    = _router_conf.router_name
        region                    = _router_conf.region
        peer_asn                  = _peer_conf.peer_asn
        interface                 = _peer_conf.interface
        peer_ip_address           = _peer_conf.peer_ip_address
        advertised_route_priority = _peer_conf.advertised_route_priority
      }
    ]
  ])
}

variable "router_conf" {
  type = list(object({
    router_name = string
    network     = string
    asn         = number
    region      = string
    interface = list(object({
      interface_name = string
      ip_range       = string
      vpn_tunnel     = string
    }))
    peer = list(object({
      peer_name                 = string
      peer_asn                  = number
      interface                 = string
      peer_ip_address           = string
      advertised_route_priority = number
    }))
  }))

  default = [
    {
      router_name = "test"
      network     = "test"
      asn         = 1123
      region      = "test"
      interface = [
        {
          interface_name = "spoke-1"
          ip_range       = "169.254.0.1/30"
          vpn_tunnel     = "spoke-1"
        },
        {
          interface_name = "spoke-2"
          ip_range       = "169.254.1.1/30"
          vpn_tunnel     = "spoke-2"
        }
      ]
      peer = [
        {
          peer_name                 = "spoke-1"
          peer_asn                  = 64515
          interface                 = "spoke-1"
          peer_ip_address           = "169.254.0.2"
          advertised_route_priority = 2000
        },
        {
          peer_name                 = "spoke-2"
          peer_asn                  = 64515
          interface                 = "spoke-2"
          peer_ip_address           = "169.254.1.2"
          advertised_route_priority = 2001
        }
      ]
    }
  ]
}

# output "_router_interface_list" {
#   value = local._router_interface_list
# }

# output "_router_peer_list" {
#   value = local._router_peer_list
# }

locals {
  _vpn_tunnel_conf_tmp = flatten([
    for _gw_conf in var.ha_vpn_conf : [
      for _tunnel_conf in _gw_conf.tunnel : {
        vpn_gateway           = _gw_conf.gw_name
        region                = _gw_conf.region
        name                  = _tunnel_conf.tunnel_name
        router                = _tunnel_conf.router
        crypto_key            = _tunnel_conf.crypto_key
        vpn_gateway_interface = _tunnel_conf.vpn_gateway_interface
      }
    ]
  ])

  _vpn_tunnel_conf_list = flatten([
    for conf in local._vpn_tunnel_conf_tmp : [
      for peer in var.peer_vpn :  merge(conf, peer) if conf.name == peer.tunnel_name
    ]
  ])
}

variable "ha_vpn_conf" {
  type = list(object({
    gw_name = string
    region  = string
    network = string
    tunnel = list(object({
      tunnel_name           = string
      crypto_key            = string
      router                = string
      vpn_gateway_interface = number
    }))
  }))

  default = [
    {
      gw_name = "test"
      region = "test"
      network = "test"
      tunnel = [
        {
          tunnel_name           = "spoke-1"
          crypto_key            = "spoke-1"
          vpn_gateway_interface = 0
          router                = "spoke"
        },
        {
          tunnel_name           = "spoke-2"
          crypto_key            = "spoke-2"
          vpn_gateway_interface = 1
          router                = "spoke"
        },
      ]
    }
  ]
}

variable "peer_vpn" {
  type = list(object({
    peer_gcp_gw = string
    tunnel_name = string
  }))

  default = [
    {
      peer_gcp_gw = "hub"
      tunnel_name = "spoke-1"
    },
    {
      peer_gcp_gw = "hub"
      tunnel_name = "spoke-2"
    }
  ]
}

# output "_vpn_tunnel_conf_list" {
#   value = local._vpn_tunnel_conf_list
# }

variable "aws_vpn" {
  type = object({
    bgp_asn        = number
    route_table_id = string
    name           = string
  })
}

variable "gcp_vpn" {
  type = object({
    name             = string
    ex_vpn_gw_name   = string
    network          = string
    main_tunnel_name = string
    sub_tunnel_name  = string
    asn              = number
  })
}

variable "region" {
  type = string
}

/*
Option Configs
*/

variable "ipsec_type" {
  type    = string
  default = "ipsec.1"
}

variable "project" {
  type    = string
  default = null
}

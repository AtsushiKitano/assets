variable "name" {
  type = string
}

variable "network" {
  type = string
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "nat_gws" {
  type = list(object({
    name                               = string
    source_subnetwork_ip_ranges_to_nat = string
    source_subnetworks = list(object({
      name                    = string
      source_ip_ranges_to_nat = list(string)
    }))
    log_config_filter = string
    min_ports_per_vm  = number
    protocol_config = object({
      tcp_established_idle_timeout_sec = number
      tcp_transitory_idle_timeout_sec  = number
      udp_idle_timeout_sec             = number
      icmp_idle_timeout_sec            = number
    })
  }))
}

/*
Option Configs
*/

variable "nat_address_redundancy" {
  type    = number
  default = 2
}

variable "bgp" {
  type = object({
    asn                  = number
    advertise_mode       = string
    advertised_groups    = string
    advertised_ip_ranges = list(string)
  })
  default = null
}

variable "router_description" {
  type    = string
  default = null
}

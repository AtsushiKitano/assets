variable "name" {
  type = string
}

variable "subnetworks" {
  type = list(object({
    name                     = string
    cidr                     = string
    region                   = string
    purpose                  = string
    role                     = string
    private_ip_google_access = bool
    secondary_ip_ranges = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
  }))
}

variable "firewalls" {
  type = list(object({
    name        = string
    direction   = string
    target_type = string
    targets     = list(string)
    ranges      = list(string)
    priority    = number
    rules = list(object({
      type     = string
      protocol = string
      ports    = list(string)
    }))
    log_config_metadata = string
  }))
}

/*

Option Configurations

*/

variable "serverless_vpc" {
  type = list(object({
    name           = string
    region         = string
    ip_cidr_range  = string
    min_throughput = number
    max_throughput = number
  }))
  default = []
}

variable "routes" {
  type = list(object({
    name             = string
    dest_range       = string
    priority         = number
    tags             = list(string)
    next_hop_gateway = string
  }))
  default = []
}

variable "route_next_hop_ip" {
  type    = map(string)
  default = null
}

variable "route_next_hop_gw" {
  type    = map(string)
  default = null
}

variable "route_next_hop_gce" {
  type    = map(string)
  default = null
}

variable "route_next_hop_vpn_tunnel" {
  type    = map(string)
  default = null
}

variable "route_next_hop_ilb" {
  type    = map(string)
  default = null
}

variable "route_next_hop_instance_zone" {
  type    = map(string)
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "vpc_network_routing" {
  type    = string
  default = "GLOBAL"
}

variable "vpc_network_mtu" {
  type    = number
  default = 1460
}

variable "delete_default_routes" {
  type    = bool
  default = false
}

variable "subnet_private_google_access" {
  type    = bool
  default = true
}

variable "subnet_log_config" {
  type = map(list(object({
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
    metadata_fields      = list(string)
    filter_expr          = string
  })))
  default = null
}

variable "fw_disabled" {
  type    = bool
  default = null
}

variable "auto_create_subnetworks" {
  type    = bool
  default = false
}

variable "peering_network_connections" {
  type = list(object({
    addresses = list(object({
      name   = string
      length = number
    }))
    service = string
  }))
  default = []
}

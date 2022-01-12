variable "service_project" {
  type = string
}

variable "host_project" {
  type = string
}

variable "shared_vpc_network" {
  type = string
}

variable "service_subnetworks" {
  type = list(object({
    name                     = string
    ip_cidr_range            = string
    region                   = string
    private_ip_google_access = bool
    secondary_ip_range = list(object({
      range_name    = string
      ip_cidr_range = string
    }))
    log_enabled = bool
    log_config = object({
      aggregation_interval = string
      flow_sampling        = string
      metadata             = string
    })
  }))
}

/*
 Option Configs
*/

variable "use_gke" {
  type    = bool
  default = false
}

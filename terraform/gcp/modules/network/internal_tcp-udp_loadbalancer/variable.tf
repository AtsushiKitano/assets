variable "backend_service" {
  type = object({
    name             = string
    lb_policy        = string
    protocol         = string
    session_affinity = string
    timeout_sec      = string
    health_checks    = list(string)
    backend = object({
      balancing_mode               = string
      group                        = string
      max_connections              = number
      max_connections_per_instance = number
      max_connections_per_endpoint = number
      max_rate                     = number
      max_rate_per_instance        = number
      max_rate_per_endpoint        = number
      max_utilization              = number
    })
  })
}

variable "forwarding_rule" {
  type = object({
    name                = string
    protocol            = string
    network             = string
    subnetwork          = string
    port_range          = string
    ports               = list(string)
    all_ports           = bool
    service_label       = string
    allow_global_access = bool
  })
}

variable "ip_address" {
  type = object({
    name    = string
    address = string
  })
}

variable "region" {
  type    = string
  default = "asia-northeast1"
}

variable "network_tier" {
  type    = string
  default = "PREMIUM"
}

variable "ip_address_purpose" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = null
}

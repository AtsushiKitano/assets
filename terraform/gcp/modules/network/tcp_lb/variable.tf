variable "name" {
  type = string
}

variable "project" {
  type = string
}

variable "address_type" {
  type = string
}

variable "network_tier" {
  type    = string
  default = "STANDARD"
}

variable "network" {
  type = string
}

variable "protocol" {
  type = string
}

variable "load_balancing_scheme" {
  type    = string
  default = "EXTERNAL"

  validation {
    condition     = var.load_balancing_scheme == "EXTERNAL" || var.load_balancing_scheme == "EXTERNAL_MANAGED" || var.load_balancing_scheme == "INTERNAL" || var.load_balancing_scheme == "INTERNAL_MANAGED"
    error_message = "the load_balancing_scheme must be EXTERNAL, EXTERNAL_MANAGED, INTERNAL or INTERNAL_MANAGED."
  }
}

variable "backends" {
  type = list(object({
    group          = string
    failover       = string
    balancing_mode = string
  }))
}

variable "health_check_name" {
  type = string
}

variable "timeout_sec" {
  type    = number
  default = 1
}

variable "check_interval_sec" {
  type    = number
  default = 1
}

variable "port" {
  type = string
}

variable "region" {
  type = string
}

variable "port_range" {
  type = string
}

variable "purpose" {
  type    = string
  default = null
}

variable "subnetwork" {
  type    = string
  default = null
}

variable "address_region" {
  type    = string
  default = null
}

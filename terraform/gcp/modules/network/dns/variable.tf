variable "dns_name" {
  type = string
}

variable "name" {
  type = string
}

variable "project" {
  type = string
}

/*
Option Values
*/

variable "description" {
  type    = string
  default = null
}

variable "visibility" {
  type    = string
  default = "public"
}

variable "private_networks" {
  type    = list(string)
  default = []
}

variable "dnssec_config" {
  type = object({
    kind          = string
    non_existence = string
    state         = string
  })
  default = null
}

variable "target_name_servers" {
  type = list(object({
    ipv4_address    = string
    forwarding_path = string
  }))
  default = []
}

variable "peering_target_network" {
  type    = list(string)
  default = []
}

variable "record_sets" {
  type = list(object({
    name    = string
    rrdatas = list(string)
    ttl     = number
    type    = string
  }))
  default = []
}

variable "default_key_specs" {
  type = object({
    algorithm  = string
    key_length = number
    key_type   = string
    kind       = string
  })
  default = null
}

variable "zone" {
  type = object({
    dns_name   = string
    name       = string
    visibility = string
  })
}

variable "private_visibility" {
  type = object({
    networks = list(string)
  })
  default = null
}

variable "dnssec" {
  type = object({
    kind          = string
    non_existence = string
    state         = string
    key_specs = object({
      algorithm  = string
      key_length = number
      key_type   = string
      kind       = string
    })
  })
  default = null
}

variable "zone_discreption" {
  type    = string
  default = null
}

variable "forwarding" {
  type = object({
    target_servers = list(object({
      ip_address = string
      path       = string
    }))
  })
  default = null
}

variable "peering" {
  type = object({
    networks = list(string)
  })
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "force_destroy" {
  type    = bool
  default = null
}


variable "records" {
  type = list(object({
    name    = string
    rrdatas = list(string)
    ttl     = number
    type    = string
  }))
}

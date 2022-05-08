variable "parent" {
  type = string
}

variable "title" {
  type = string
}

variable "restricted_services" {
  type = list(string)
}

variable "access_levels" {
  type = list(string)
}

/*
  Option Variables
*/

variable "ingress_policies" {
  type = list(object({
    from = object({
      identity_type = string
      identities    = list(string)
      access_levels = list(string)
      resource      = list(string)
    })
    to = object({
      resources = list(string)
      operations = object({
        service_name = string
        method_selectors = list(object({
          method     = string
          permission = string
        }))
      })
    })
  }))
  default = []
}

variable "egress_policies" {
  type = list(object({
    from = object({
      identity_type = string
      identities    = list(string)
      access_levels = list(string)
      resource      = list(string)
    })
    to = object({
      resources = list(string)
      operations = object({
        service_name = string
        method_selectors = list(object({
          method     = string
          permission = string
        }))
      })
    })
  }))
  default = []
}

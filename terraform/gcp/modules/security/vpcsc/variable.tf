variable "access_policy" {
  type = object({
    parent = string
    title  = string
  })
}

variable "service_perimeters" {
  type = list(object({
    title          = string
    perimeter_type = string
    status = object({
      access_levels       = list(string)
      restricted_services = list(string)
      resources           = list(string)
      vpc_accessible_services = list(object({
        enable_restriction = string
        allowed_services   = list(string)
      }))
    })
  }))
}

variable "access_levels" {
  type = list(object({
    name = string
    basic = object({
      combining_function = string
      conditions = list(object({
        ip_subnetworks         = list(string)
        required_access_levels = list(string)
        members = list(object({
          type    = string
          member  = string
          project = string
        }))
        regions = list(string)
      }))
    })
  }))
  default = []
}

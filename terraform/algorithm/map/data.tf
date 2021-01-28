variable "sample" {
  type = list(object({
    name = string
    data = list(object({
      ip = string
    }))
  }))
  default = [
    {
      name = "test"
      data = [
        {
          ip = "192.168.20.2"
        },
        {
          ip = "192.168.20.3"
        }
      ]
    },
    {
      name = "test2"
      data = [
        {
          ip = "192.168.30.2"
        },
        {
          ip = "192.168.30.3"
        }
      ]
    }
  ]
}

variable "marged" {
  type = list(object({
    name = string
    date = string
  }))
  default = [
    {
      name = "test"
      date = "19881010"
    },
    {
      name = "skhl"
      date = "19921023"
    }
  ]
}

output "_marged_map" {
  value = local._marged_map
}

locals {
  _marged_map = distinct(flatten([
    for v in var.sample : [
      for v2 in var.marged : merge(v, v2) if v.name == v2.name
    ]
  ]))
}


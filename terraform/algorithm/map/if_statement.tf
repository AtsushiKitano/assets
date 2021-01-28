locals {
  _nw_conf = flatten([
    for _conf in var.network_sample : {
      name = _conf.nw_conf.vpc_network
      auto_create_subnetworks = _conf.nw_conf.auto_create_subnetworks
    } if _conf.nw_enable
  ])

  _subnet_conf = flatten([
    for _conf in var.network_sample : [
      for _sub in _conf.subnetwork : {
        name = _sub.name
        cidr = _sub.cidr
        region = _sub.region
        network = _conf.nw_conf.vpc_network
      }
    ] if _conf.subnet_enable
  ])
}

variable "network_sample" {
  type = list(object({
    nw_enable     = bool
    subnet_enable = bool

    nw_conf = object({
      vpc_network             = string
      auto_create_subnetworks = bool
    })

    subnetwork = list(object({
      name   = string
      cidr   = string
      region = string
    }))

  }))

  default = [
    {
      nw_enable     = true
      subnet_enable = true
      nw_conf = {
        vpc_network             = "test"
        auto_create_subnetworks = false
      }

      subnetwork = [
        {
          name   = "test"
          cidr   = "192.168.10.0/24"
          region = "asia-northeast1"
        }
      ]
    },
    {
      nw_enable     = true
      subnet_enable = true
      nw_conf = {
        vpc_network             = "test2"
        auto_create_subnetworks = false
      }

      subnetwork = [
        {
          name   = "test"
          cidr   = "192.168.10.0/24"
          region = "asia-northeast1"
        }
      ]
    }

  ]
}

# output "if_sample" {
#   value = local._subnet_conf
# }

locals {
  config = jsondecode(file(var.file_path))
}

module "network_file" {
  for_each = { for v in local.config : v.name => v }
  source   = "../../../network/vpc_network"

  project = each.value.project

  vpc_network = {
    name = each.value.name
  }

  subnetworks = [
    for v in each.value.subnetworks : {
      name   = v.name
      cidr   = v.cidr
      region = v.region
    }
  ]

  firewall = [
    for v in each.value.firewalls : {
      name      = v.name
      direction = v.direction
      tags      = v.tags
      ranges    = v.ranges
      priority  = tonumber(v.priority)
      rules = [
        for w in v.rules : {
          type     = w.type
          protocol = w.protocol
          ports    = w.ports
        }
      ]
      log_config_metadata = null
    }
  ]
}

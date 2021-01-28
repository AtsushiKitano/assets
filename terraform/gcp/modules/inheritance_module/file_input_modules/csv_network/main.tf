locals {
  firewall_config = csvdecode(file(var.firewall_file))
  network_config  = csvdecode(file(var.network_file))

  _vpc_nws = distinct([
    for v in local.network_config : {
      name    = v.vpc_network
      project = v.project
    }
  ])

  network_info = [
    for v in local._vpc_nws : {
      name    = v.name
      project = v.project
      subnets = flatten(concat([
        for w in local.network_config : v.name == w.vpc_network && v.project == w.project ? [{
          name   = w.subnetwork
          cidr   = w.cidr
          region = w.region
        }] : []
      ]))
      firewalls = flatten(concat([
        for w in local.firewall_config : v.name == w.network ? [
          {
            name      = w.name
            priority  = tonumber(w.priority)
            ranges    = split(" ", w.ranges)
            direction = w.direction
            rules = [
              {
                type     = w.rule_type
                protocol = w.rule_protocol
                ports    = split(" ", w.rule_ports)
              }
            ]
            tags = compact(split(" ", w.tags))
          }
        ] : []
      ]))
    }
  ]
}


module "network_file" {
  for_each = { for v in local.network_info : v.name => v }
  source   = "../../../network/vpc_network"

  project = each.value.project

  vpc_network = {
    name = each.value.name
  }

  subnetworks = [
    for v in each.value.subnets : {
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
      priority  = v.priority
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

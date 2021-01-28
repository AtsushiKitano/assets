locals {
  firewall_config = csvdecode(file("./firewall.csv"))
  network_config  = csvdecode(file("./vpc_network.csv"))

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
            name     = w.name
            priority = tonumber(w.priority)
            ranges   = split(" ", w.ranges)
            rules = [
              {
                type     = w.rules1_type
                protocol = w.rules1_protocol
                ports    = split(" ", w.rules1_ports)
              }
            ]
            tags = compact(split(" ", w.tags))
          }
        ] : []
      ]))
    }
  ]
}

output "nw_info" {
  value = local.network_info
}

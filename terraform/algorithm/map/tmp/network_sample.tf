locals {
  _network_conf = flatten([
    for _conf in var.network_conf : {
      name = _conf.vpc_network_conf.name
      auto_create_subnetworks = _conf.vpc_network_conf.auto_create_subnetworks
    } if _conf.vpc_network_enable
  ])

  _subnet_conf = flatten([
    for _conf in var.network_conf : [
      for _subnet in _conf.subnetwork : {
        name = _subnet.name
        cidr = _subnet.cidr
        region = _subnet.region
        network = _conf.vpc_network_conf.name
      }
    ] if _conf.subnetwork_enable
  ])

  _fw_egress_list = flatten([
    for _conf in var.network_conf : [
      for _fw_conf in _conf.firewall_egress_conf : {
        name               = _fw_conf.name
        network            = _conf.vpc_network_conf.name
        priority           = _fw_conf.priority
        enable_logging     = _fw_conf.enable_logging
        destination_ranges = _fw_conf.destination_ranges
        target_tags        = _fw_conf.target_tags
        allow_rules        = _fw_conf.allow_rules
        deny_rules         = _fw_conf.deny_rules
      }
    ] if _conf.firewall_egress_enable
  ])

  _fw_ingress_list = flatten([
    for _conf in var.network_conf : [
      for _fw_conf in _conf.firewall_ingress_conf : {
        name           = _fw_conf.name
        network        = _conf.vpc_network_conf.name
        priority       = _fw_conf.priority
        enable_logging = _fw_conf.enable_logging
        source_ranges  = _fw_conf.source_ranges
        target_tags    = _fw_conf.target_tags
        allow_rules    = _fw_conf.allow_rules
        deny_rules     = _fw_conf.deny_rules
      }
    ] if _conf.firewall_ingress_enable
  ])

  _route_conf_list = flatten([
    for _conf in var.network_conf : [
      for _route_conf in _conf.route_conf : {
        name             = _route_conf.name
        network          = _conf.vpc_network_conf.name
        dest_range       = _route_conf.dest_range
        priority         = _route_conf.priority
        tags             = _route_conf.tags
        next_hop_gateway = _route_conf.next_hop_gateway
      }
    ] if _conf.route_enable
  ])
}



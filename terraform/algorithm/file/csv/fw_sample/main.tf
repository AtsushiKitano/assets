locals {
  protocols = [
    "tcp",
    "udp"
  ]
}

locals {
  fw_list = csvdecode(file("./firewall.csv"))

  _name_list = distinct([
    for _fw in local.fw_list : _fw.name
  ])

  _ports_map = {
    for _n in local._name_list : _n => [
      for _conf in local.fw_list : {
        ports    = _conf.allow_ports
        protocol = _conf.allow_protocol
      } if _conf.name == _n
    ]
  }

  _ports = [
    for _p in local.protocols : {
      for _n in local._ports_map : _n.key => _n.ports if _n.protocol == _p
    }
  ]

  # _ports_map = {
  #   for _n in local._name_list : _n => [
  #     for _fw in local.fw_list : _fw.allow_ports if _fw.name == _n
  #   ]
  # }

  # _fw_conf = flatten([
  #   for _conf in local.fw_list : {
  #     name = _conf.name
  #     allow = {
  #       protocol = _conf.allow_protocol
  #       ports = local._ports_map[_conf.name]
  #     }
  #     priority = _conf.priority
  #   }
  # ])

  # _fc = distinct(local._fw_conf)
}

output "file" {
  # value = local.fw_list
  # value = local._fw_conf
  # value = local._fc
  value = local._ports_map
}

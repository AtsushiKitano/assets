locals {
  network_conf = yamldecode(file(var.file_path))

  _network_conf = flatten([
    for _conf in local.network_conf : {
      name = _conf.vpc_network_conf.name
      auto_create_subnetworks = _conf.vpc_network_conf.auto_create_subnetworks
    } if _conf.vpc_network_enable
  ])

  _subnet_conf = flatten([
    for _conf in local.network_conf : [
      for _subnet in _conf.subnetwork : {
        name = _subnet.name
        cidr = _subnet.cidr
        region = _subnet.region
        network = _conf.vpc_network_conf.name
      }
    ] if _conf.subnetwork_enable && _conf.vpc_network_enable
  ])
}
resource "google_compute_network" "main" {
  for_each = { for v in local._network_conf : v.name => v }

  name                    = each.value.name
  auto_create_subnetworks = each.value.auto_create_subnetworks
}

resource "google_compute_subnetwork" "main" {
  for_each = { for v in local._subnet_conf : v.name => v }

  name          = each.value.name
  network       = google_compute_network.main[each.value.network].self_link
  ip_cidr_range = each.value.cidr
  region        = each.value.region
}

output "file" {
  value = local.network_conf
}

locals {
  peering_sample_enable = false

  _peering_sample = local.peering_sample_enable ? ["enable"] : []
  _peering_sample_network = local.peering_sample_enable ? [
    "sample1",
    "sample2"
  ] : []
}

module "peering_sample" {
  for_each = toset(local._peering_sample)
  source   = "../modules/network/peering"

  peering = {
    main_name = "sample1-sample2"
    sub_name  = "sample2-sample1"
    network = [
      for v in local._peering_sample_network : module.peering_sample_network[v].id
    ]
  }
}

module "peering_sample_network" {
  for_each = toset(local._peering_sample_network)
  source   = "../modules/network/vpc_network"

  project = terraform.workspace

  vpc_network = {
    name = each.value
  }
  subnetworks = []
  firewall    = []
}

locals {
  composer_sample_enabled = false

  _composer_configs = local.composer_sample_enabled ? [
    {
      name         = "sample-composer"
      node_count   = 3
      machine_type = "n1-standard-1"
      network      = "sample"
      cidr         = "192.168.10.0/28"
      region       = "us-central1"
      zone         = "us-central1-f"
    }
  ] : []
}

module "composer_sample" {
  for_each = { for v in local._composer_configs : v.name => v }
  source   = "../modules/bigdata/composer"

  config = {
    name         = each.value.name
    node_count   = each.value.node_count
    machine_type = each.value.machine_type
    network      = module.composer_sample_network[each.value.name].self_link
    subnetwork   = module.composer_sample_network[each.value.name].subnetwork_self_link[each.value.network]
  }

  region = each.value.region
  zone   = each.value.zone

}

module "composer_sample_network" {
  for_each = { for v in local._composer_configs : v.name => v }
  source   = "../modules/network/vpc_network"

  vpc_network = {
    name = each.value.network
  }

  subnetworks = [
    {
      name   = each.value.network
      cidr   = each.value.cidr
      region = each.value.region
    }
  ]

  subnet_private_google_access = true

  firewall = [
    {
      direction = "INGRESS"
      name      = "ingress-sample-composer"
      tags      = []
      ranges    = ["0.0.0.0/0"]
      priority  = 1000
      rules = [
        {
          type     = "allow"
          protocol = "tcp"
          ports    = ["22", "443", "80"]
        }
      ]
      log_config_metadata = null
    },
  ]
}

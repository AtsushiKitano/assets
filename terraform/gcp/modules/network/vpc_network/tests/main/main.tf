locals {
  inspec_test_infra_enable = true

  _inspec_test_network = local.inspec_test_infra_enable ? [
    {
      network = "test"
      subnets = [
        {
          name   = "test-tokyo"
          cidr   = "192.168.0.0/29"
          region = "asia-northeast1"
        },
        {
          name   = "test-osaka"
          cidr   = "192.168.0.8/29"
          region = "asia-northeast2"
        }
      ]
    }
  ] : []

  _inspec_test_gce = local.inspec_test_infra_enable ? [
    {
      name         = "test-tokyo"
      machine_type = "f1-micro"
      zone         = "asia-northeast1-b"
      subnetwork   = "test-tokyo"
      tags         = ["test"]
      size         = 20
      image        = "ubuntu-os-cloud/ubuntu-2004-lts"
    },
    {
      name         = "test-osaka"
      machine_type = "f1-micro"
      zone         = "asia-northeast2-b"
      subnetwork   = "test-osaka"
      tags         = ["test"]
      size         = 20
      image        = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  ] : []
}

module "network" {
  for_each = { for v in local._inspec_test_network : v.network => v }
  source   = "./terraform/gcp/modules/network/vpc_network"

  vpc_network = {
    name = each.value.network
  }

  subnetworks = [
    for v in each.value.subnets : v
  ]

  firewall = []
}

module "gce" {
  for_each = { for v in local._inspec_test_gce : v.name => v }
  source   = "./terraform/gcp/modules/compute/gce"

  gce_instance = {
    name         = each.value.name
    machine_type = each.value.machine_type
    zone         = each.value.zone
    subnetwork   = module.network["test"].subnetwork_self_link[each.value.subnetwork]
    tags         = each.value.tags
  }

  boot_disk = {
    name      = each.value.name
    size      = each.value.size
    interface = null
    image     = each.value.image
  }
}

locals {
  gce_sample_enable = false

  _gce_sample_enable = local.gce_sample_enable ? ["enable"] : []
}

module "gce_sample" {
  for_each = toset(local._gce_sample_enable)
  source   = "../modules/compute/gce"

  gce_instance = {
    name         = "sample"
    machine_type = "f1-micro"
    zone         = "asia-northeast1-b"
    subnetwork   = module.gce_nw_sample["enable"].subnetwork_self_link["sample"]
    tags         = []
  }

  boot_disk = {
    name      = "sample"
    size      = 20
    interface = null
    image     = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  service_account = module.gce_sa_sample["enable"].email
}

module "gce_nw_sample" {
  for_each = toset(local._gce_sample_enable)
  source   = "../modules/network/vpc_network"

  project = terraform.workspace

  vpc_network = {
    name = "sample"
  }
  subnetworks = [
    {
      name   = "sample"
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    },
  ]

  firewall = [
    {
      direction = "INGRESS"
      name      = "ingress-sample"
      tags      = []
      ranges    = ["0.0.0.0/0"]
      priority  = 1000
      rules = [
        {
          type     = "allow"
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      log_config_metadata = null
    },
  ]
}

module "gce_sa_sample" {
  for_each = toset(local._gce_sample_enable)
  source   = "../modules/iam/service_account"

  service_account = {
    name = "sample"
    roles = [
      "editor"
    ]
  }
}

output "gce_sample" {
  value = module.gce_sample
}

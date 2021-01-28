locals {
  vpc_network_sample_enable = false

  _vpc_nw_enable = local.vpc_network_sample_enable ? ["enable"] : []

}

module "network_sample" {
  for_each = toset(local._vpc_nw_enable)
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
    {
      name   = "sample2"
      cidr   = "192.168.20.0/24"
      region = "asia-northeast1"
    }
  ]

  subnet_log_config = {
    sample = [
      {
        aggregation_interval = "INTERVAL_5_SEC"
        flow_sampling        = 0.7
        metadata             = "INCLUDE_ALL_METADATA"
        metadata_fields      = null
        filter_expr          = null
      }
    ]
  }

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
    {
      direction = "EGRESS"
      name      = "deny-sample"
      tags      = []
      ranges    = ["0.0.0.0/0"]
      priority  = 65535
      rules = [
        {
          type     = "deny"
          protocol = "all"
          ports    = []
        }
      ]
      log_config_metadata = null
    }

  ]
}

output "network_sample" {
  value = module.network_sample
}

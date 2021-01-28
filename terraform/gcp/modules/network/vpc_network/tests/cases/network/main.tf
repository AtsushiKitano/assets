locals {
  inspec_test_infra_enable = true

  _insple_test = local.inspec_test_infra_enable ? [
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
      firewalls = [
        {
          name                = "test-ingress"
          direction           = "INGRESS"
          tags                = ["test"]
          ranges              = ["0.0.0.0/0"]
          priority            = 1000
          log_config_metadata = "EXCLUDE_ALL_METADATA"
          rules = [
            {
              type     = "allow"
              protocol = "tcp"
              ports    = ["22"]
            }
          ]
        },
        {
          name                = "test-egress"
          direction           = "EGRESS"
          tags                = ["test"]
          ranges              = ["0.0.0.0/0"]
          priority            = 1000
          log_config_metadata = null
          rules = [
            {
              type     = "deny"
              protocol = "all"
              ports    = []
            }
          ]
        }
      ]
    }
  ] : []
}

module "main" {
  for_each = { for v in local._insple_test : v.network => v }
  source   = "../../.."

  vpc_network = {
    name = each.value.network
  }

  subnetworks = [
    for v in each.value.subnets : v
  ]

  firewall = [
    for v in each.value.firewalls : v
  ]
}

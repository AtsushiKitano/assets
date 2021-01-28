locals {
  dns_sample_enable  = false
  _dns_sample_enable = local.dns_sample_enable ? ["enable"] : []
}

module "dns_sample" {
  for_each = toset(local._dns_sample_enable)
  source   = "../modules/network/dns"

  zone = {
    dns_name   = "googleapi-zone"
    name       = "googleapis.com."
    visibility = "private"
  }

  private_visibility = {
    networks = [
      module.dns_sample_network["enable"].id
    ]
  }

  records = [
    {
      name    = "*.googleapis.com."
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["restricted.googleapis.com."]
    },
    {
      name = "restricted.googleapis.com."
      type = "A"
      ttl  = 300
      rrdatas = [
        "199.36.153.4",
        "199.36.153.5",
        "199.36.153.6",
        "199.36.153.7",
      ]
    }
  ]
}

module "dns_sample_network" {
  for_each = toset(local._dns_sample_enable)
  source   = "../modules/network/vpc_network"

  vpc_network = {
    name = "sample"
  }
  subnetworks = []

  firewall = []
}

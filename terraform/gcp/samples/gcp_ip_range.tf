locals {
  gcp_ip_address_sample_enable = false

  _gcp_ip_address_sample = local.gcp_ip_address_sample_enable ? [
    "cloud",
    "google",
    "restricted",
    "private",
    "dns",
    "iap",
    "health",
    "lh",
    "all"
  ] : []
}

module "gcp_ip_address_refer_sample" {
  for_each = toset(local._gcp_ip_address_sample)
  source   = "../modules/network/refer_address"

  range_type = each.value
}

output "gcp_ip_address_refer_sample" {
  value = module.gcp_ip_address_refer_sample
}

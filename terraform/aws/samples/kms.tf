locals {
  kms_sample_enabled = false

  _kms_sample_config = local.kms_sample_enabled ? [
    {
      name = "sample"
    }
  ] : []
}

module "kms_sample" {
  for_each = { for v in local._kms_sample_config : v.name => v }
  source   = "../modules/secret/kms"

  config = {
    name = each.value.name

    grants = []
  }
}

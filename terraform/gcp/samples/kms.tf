locals {
  kms_sample_enable = false

  keys = [
    "sample"
  ]

  _kms_sample = local.kms_sample_enable ? ["enable"] : []
}

module "kms_sample" {
  for_each = toset(local._kms_sample)
  source   = "../modules/security/kms"

  key_ring = {
    name     = "sample"
    location = "asia-northeast1"
  }

  keys = [
    for key in local.keys : {
      name = key
    }
  ]
}

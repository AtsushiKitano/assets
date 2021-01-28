locals {
  gcs_sample_enable = false

  _gcs_enable = local.gcs_sample_enable ? ["enable"] : []
}

module "gcs_sample" {
  for_each = toset(local._gcs_enable)
  source   = "../modules/data/gcs"

  bucket = {
    name     = join("-", [terraform.workspace, "sample-module"])
    location = "asia-northeast1"
  }
}

output "gcs_sample" {
  value = module.gcs_sample
}

locals {
  build_sample_enable = false

  _build_sample = local.build_sample_enable ? ["enable"] : []
}

module "build_sample" {
  for_each = toset(local._build_sample)
  source   = "../modules/tool/build"

  trigger = {
    name          = "sample"
    filename      = "terraform/gcp/modules/network/tests/cloudbuild/golang_sdk_test.yaml"
    substitutions = null
  }

  trigger_template = null
  github = {
    owner = "AtsushiKitano"
    name  = "assets"
    push = {
      branch       = "master"
      invert_regex = null
      tag          = null
    }
  }
}

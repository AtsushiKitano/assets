locals {
  cloud_run_sample_enabled = false

  _cloud_run_sample_conf = local.cloud_run_sample_enabled ? [
    {
      name     = "sample"
      location = "asia-northeast1"
      image    = "gcr.io/ca-kitano-study-sandbox/helloworld"
    }
  ] : []
}

module "cloud_run_sample" {
  for_each = { for v in local._cloud_run_sample_conf : v.name => v }
  source   = "../modules/compute/cloud_run"

  config = {
    name     = each.value.name
    location = each.value.location
    spec = {
      container_concurrency = null
      timeout_seconds       = null
    }

    containers = {
      args    = []
      command = []
      image   = each.value.image
    }
  }
}

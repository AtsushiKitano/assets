locals {
  enabled = false

  _conf = local.enabled ? [
    {
      name     = "sample"
      location = "asia-northeast1"
      image    = "gcr.io/ca-kitano-study-sandbox/helloworld"
    }
  ] : []
}

module "sample" {
  for_each = { for v in local._conf : v.name => v }
  source   = "github.com/AtsushiKitano/assets/terraform/gcp/modules/compute/cloud_run"

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

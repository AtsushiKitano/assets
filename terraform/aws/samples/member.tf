locals {
  account_sample_enabled = false

  _account_sample_config = local.account_sample_enabled ? [
    {
      name   = "sample"
      status = "Active"
      key    = file("keys/sample.public.gpg.base64")
    }
  ] : []
}

module "account_sample" {
  for_each = { for v in local._account_sample_config : v.name => v }
  source   = "../modules/iam/account"

  config = {
    name = each.value.name
    path = null
    access_key = {
      status = each.value.status
    }
  }
  key = each.value.key
}

output "account_sample" {
  value = module.account_sample
}

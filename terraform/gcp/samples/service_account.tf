locals {
  service_account_enable = false

  _sa_enable = local.service_account_enable ? ["enable"] : []
}

module "service_account_sample" {
  for_each = toset(local._sa_enable)
  source   = "../modules/iam/service_account"

  service_account = {
    name = "sample"
    roles = [
      "editor"
    ]
  }
}

output "service_account_sample" {
  value = module.service_account_sample
}

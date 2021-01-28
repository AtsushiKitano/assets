locals {
  vpc_sample_enabled = false

  _vpc_sample_conf = local.vpc_sample_enabled ? [
    {
      name = "sample"
      cidr = "192.168.0.0/16"
      subnets = [
        {
          name = "sample"
          cidr = "192.168.10.0/24"
          az   = join("", [local.env[terraform.workspace], "b"])
        },
        {
          name = "sample2"
          cidr = "192.168.20.0/24"
          az   = join("", [local.env[terraform.workspace], "c"])
        }
      ]
    }
  ] : []
}

module "network" {
  for_each = { for v in local._vpc_sample_conf : v.name => v }
  source   = "../modules/network/vpc"

  config = {
    vpc = {
      name = each.value.name
      cidr = each.value.cidr
    }

    subnets = each.value.subnets
  }
}

output "network" {
  value = module.network
}

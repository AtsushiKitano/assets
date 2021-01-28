locals {
  route_sample_enabled = false

  _route_configs = local.route_sample_enabled ? [
    {
      name = "sample"
      network = {
        cidr = "192.168.0.0/16"
        subnets = [
          {
            name = "sample"
            cidr = "192.168.10.0/24"
            az   = join("", [local.env[terraform.workspace], "b"])
          }
        ]
      }
      route = {
        routes = [
          {
            dest_cidr = "0.0.0.0/0"
          }
        ]
      }
    }
  ] : []
}

module "route_sample" {
  for_each = { for v in local._route_configs : v.name => v }
  source   = "../modules/network/route"

  config = {
    name   = each.value.name
    vpc_id = module.route_sample_vpc[each.value.name].vpc_id

    routes = [
      for v in each.value.route.routes : {
        dest_cidr   = v.dest_cidr
        gwid        = module.route_sample_vpc[each.value.name].igw
        instance_id = null
        nat_gw      = null
      }
    ]
  }
}

module "route_sample_vpc" {
  for_each = { for v in local._route_configs : v.name => v }
  source   = "../modules/network/vpc"

  config = {
    vpc = {
      name = each.value.name
      cidr = each.value.network.cidr
    }

    subnets = each.value.network.subnets
  }
}

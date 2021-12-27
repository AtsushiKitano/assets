locals {
  acl_sample_enabled = false

  _acl_configs = local.acl_sample_enabled ? [
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
      security = {
        sg_rules = [
          {
            type        = "ingress"
            cidr_blocks = ["0.0.0.0/0"]
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
          }
        ]
        ncl_rules = [
          {
            rule_number = 100
            egress      = false
            protocol    = "tcp"
            rule_action = "allow"
            cidr        = "192.168.0.0/16"
            from_port   = 22
            to_port     = 22
          }
        ]
      }
    }
  ] : []
}

module "acl_sample" {
  for_each = { for v in local._acl_configs : v.name => v }
  source   = "../modules/network/acl"

  vpc_id = module.acl_sample_vpc[each.value.name].vpc_id

  sg = {
    name = each.value.name

    rules = [
      for v in each.value.security.sg_rules : {
        type        = v.type
        cidr_blocks = v.cidr_blocks
        from_port   = v.from_port
        to_port     = v.to_port
        protocol    = v.protocol
      }
    ]
  }


  ncl = {
    name       = each.value.name
    subnet_ids = []
    rules = [
      for v in each.value.security.ncl_rules : {
        rule_number = v.rule_number
        egress      = v.egress
        protocol    = v.protocol
        rule_action = v.rule_action
        cidr        = v.cidr
        from_port   = v.from_port
        to_port     = v.to_port
        icmp_type   = null
        icmp_code   = null
      }
    ]
  }

  default_acl = {
    name               = each.value.name
    vpc_default_acl_id = module.acl_sample_vpc[each.value.name].default_network_acl_id
    subnets            = []
    ingress            = []
    egress             = []
    tags               = {}
  }
}

module "acl_sample_vpc" {
  for_each = { for v in local._acl_configs : v.name => v }
  source   = "../modules/network/vpc"

  config = {
    vpc = {
      name = each.value.name
      cidr = each.value.network.cidr
    }

    subnets = each.value.network.subnets
  }
}

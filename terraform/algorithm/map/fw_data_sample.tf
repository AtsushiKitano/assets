locals {
  _fw_ingress_list = flatten([
    for v in var.network_conf : [
      for fw_conf in v.ingress_conf : {
        name = fw_conf.name
        network = v.vpc_network
        priority = fw_conf.priority
        enable_logging = fw_conf.enable_logging
        destination_ranges = fw_conf.destination_ranges
        target_tags = fw_conf.target_tags
        allow_rules = fw_conf.allow_rules
      }
    ]
  ])
}

variable "network_conf" {
  type = list(object({
    vpc_network = string
    auto_create_subnetworks = bool
    subnetwork = list(object({
      name = string
      cidr = string
      region = string
    }))
    ingress_conf = list(object({
      name = string
      priority = number
      enable_logging = bool
      destination_ranges = list(string)
      target_tags = list(string)
      allow_rules = list(object({
        protocol = string
        ports = list(string)
      }))
    }))
  }))

  default = [
    {
      vpc_network = "test"
      auto_create_subnetworks = false
      subnetwork = [
        {
          name = "test"
          cidr = "102"
          region = "asia"
        }
      ]
      ingress_conf = [
        {
          name = "test"
          priority = 1000
          enable_logging = false
          destination_ranges = ["10"]
          target_tags = ["tes"]
          allow_rules = [
            {
              protocol = "tcp"
              ports = ["22"]
            }
          ]
        }
      ]
    }
  ]
}

# output "test" {
#   value = local._fw_ingress_list
# }

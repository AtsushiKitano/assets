variable "network_conf" {
  type = list(object({
    vpc_network_enable      = bool
    subnetwork_enable       = bool
    firewall_ingress_enable = bool
    firewall_egress_enable  = bool
    route_enable            = bool

    vpc_network_conf = object({
      name                    = string
      auto_create_subnetworks = bool
    })

    subnetwork = list(object({
      name   = string
      cidr   = string
      region = string
    }))

    firewall_ingress_conf = list(object({
      name           = string
      priority       = number
      enable_logging = bool
      source_ranges  = list(string)
      target_tags    = list(string)
      allow_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      deny_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
    }))

    firewall_egress_conf = list(object({
      name               = string
      priority           = number
      enable_logging     = bool
      destination_ranges = list(string)
      target_tags        = list(string)
      allow_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
      deny_rules = list(object({
        protocol = string
        ports    = list(string)
      }))
    }))

    route_conf = list(object({
      name             = string
      dest_range       = string
      priority         = number
      tags             = list(string)
      next_hop_gateway = string
    }))
  }))

  default = [
    {
      vpc_network_enable      = true
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = true
      route_enable            = true

      vpc_network_conf = {
        name             = "test"
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = "test"
          cidr   = "192.168.0.0/24"
          region = "test"
        }
      ]
      firewall_ingress_conf = [
        {
          name           = "test-ssh-ingress"
          priority       = 1000
          enable_logging = false
          source_ranges = [
            "0.0.0.0/0"
          ]
          target_tags = [
            "test"
          ]
          allow_rules = [
            {
              protocol = "tcp"
              ports    = ["22"]
            }
          ]
          deny_rules = []
        }
      ]
      firewall_egress_conf = []
      route_conf = [
        {
          name       = "test"
          dest_range = "0.0.0.0/0"
          priority   = 1000
          tags = [
            "test"
          ]
          next_hop_gateway = "default-internet-gateway"
        }
      ]
    },
    {
      vpc_network_enable      = true
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = true
      route_enable            = true

      vpc_network_conf = {
        name             = "test2"
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = "test"
          cidr   = "192.168.0.0/24"
          region = "test"
        }
      ]
      firewall_ingress_conf = [
        {
          name           = "test2-ssh-ingress"
          priority       = 1000
          enable_logging = false
          source_ranges = [
            "0.0.0.0/0"
          ]
          target_tags = [
            "test"
          ]
          allow_rules = [
            {
              protocol = "tcp"
              ports    = ["22"]
            }
          ]
          deny_rules = []
        }
      ]
      firewall_egress_conf = []
      route_conf = [
        {
          name       = "test2"
          dest_range = "0.0.0.0/0"
          priority   = 1000
          tags = [
            "test"
          ]
          next_hop_gateway = "default-internet-gateway"
        }
      ]
    },
  ]
}

output "nw_sample_out" {
  value = local._subnet_conf
}

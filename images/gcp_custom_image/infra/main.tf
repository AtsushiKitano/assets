locals {
  region = "asia-northeast1"
  zone = "asia-northeast1-b"
  network = "custom-img"
  subnetwork = {
    name = "custom-img"
    cidr = "192.168.0.0/29"
  }
}

module "custom_img_network" {
  source = "../../../terraform/gcp/modules/network"

  network_conf = [
    {
      vpc_network_enable      = false
      subnetwork_enable       = true
      firewall_ingress_enable = false
      firewall_egress_enable  = true
      route_enable            = true

      vpc_network_conf = {
        name                    = local.network
        opt_conf = {}
      }
      subnetwork = [
        {
          name        = local.subnetwork.name
          cidr        = local.subnetwork.cidr
          description = "test"
          region      = local.region
          opt_conf = {}
        }
      ]
      firewall_ingress_conf = [
        {
          name          = "custom-img-ssh"
          priority      = 1000
          source_ranges = ["0.0.0.0/0"]
          target_tags   = []
          allow_rules = [
            {
              protocol = "tcp"
              ports    = ["22"]
            }
          ]
          deny_rules = []
          opt_conf = {}
        }
      ]
      firewall_egress_conf = []
      route_conf = [
        {
          name             = "custom-img-internet-access"
          dest_range       = "0.0.0.0/0"
          tags             = []
          opt_conf = {
            next_hop_gateway = "default-internet-gateway"
          }
        }
      ]
    }
  ]
}

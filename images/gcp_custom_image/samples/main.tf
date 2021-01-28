locals {
  zone   = "asia-northeast1-b"
  region = "asia-northeast1"
  network = "custom-img"
  subnet = {
    name = "custom-img"
    cidr = "192.168.0.0/29"
  }
}

variable "image" {
  type = string
}

module "gce" {
  depends_on = [ module.nw ]
  source = "../../../terraform/gcp/modules/gce"

  gce_conf = [
    {
      gce_enable         = false
      preemptible_enable = false

      name         = "custom-img-demo"
      machine_type = "f1-micro"
      zone         = local.zone
      region       = local.region
      tags         = ["test"]
      network      = local.subnet.name
      boot_disk = {
        size        = 10
        image       = var.image
        type        = "pd-ssd"
        auto_delete = true
      }
      access_config = {
        nat_ip = null
      }
    }
  ]
}

module "nw" {
  source = "../../../terraform/gcp/modules/network"

  network_conf = [
    {
      vpc_network_enable      = false
      subnetwork_enable       = true
      firewall_ingress_enable = true
      firewall_egress_enable  = false
      route_enable            = true

      vpc_network_conf = {
        name                    = "custom-img"
        auto_create_subnetworks = false
      }
      subnetwork = [
        {
          name   = local.subnet.name
          cidr   = local.subnet.cidr
          region = local.region
        }
      ]
      firewall_ingress_conf = [
        {
          name           = "docker-custom-img"
          priority       = 1000
          enable_logging = false
          source_ranges  = ["0.0.0.0/0"]
          target_tags    = []
          allow_rules = [
            {
              protocol = "tcp"
              ports    = ["22", "80"]
            }
          ]
          deny_rules = []
        }
      ]
      firewall_egress_conf = []
      route_conf = [
        {
          name             = "docker-route"
          dest_range       = "0.0.0.0/0"
          priority         = 1000
          tags             = []
          next_hop_gateway = "default-internet-gateway"
        }
      ]
    }
  ]
}

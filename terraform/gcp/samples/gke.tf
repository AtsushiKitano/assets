locals {
  gke_sample_enable = false

  _gke_enable = local.gke_sample_enable ? ["enable"] : []
}

module "gke_sample" {
  for_each = toset(local._gke_enable)
  source   = "../modules/compute/gke"

  cluster_name      = ""
  project           = ""
  region            = ""
  subnetwork        = ""
  cluster_ipv4_cidr = ""

  node_pools = [
    {
      name             = ""
      disk_size_gb     = 100
      disk_type        = "SSD"
      image_type       = ""
      machine_type     = ""
      service_account  = ""
      tags             = []
      autoscaling      = null
      management       = null
      upgrade_settings = null
    }
  ]
}

module "gke_network_sample" {
  for_each = toset(local._gke_enable)
  source   = "../modules/network/vpc_network"

  project = terraform.workspace

  vpc_network = {
    name = "sample"
  }
  subnetworks = [
    {
      name   = "sample"
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    },
  ]

  firewall = [
    {
      direction = "INGRESS"
      name      = "ingress-sample"
      tags      = []
      ranges    = ["0.0.0.0/0"]
      priority  = 1000
      rules = [
        {
          type     = "allow"
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
      log_config_metadata = null
    },
  ]
}

module "gke_sa_sample" {
  for_each = toset(local._gke_enable)

  source = "../modules/iam/service_account"

  service_account = {
    name = "sample"
    roles = [
      "editor"
    ]
  }
}

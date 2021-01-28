locals {
  gke_sample_enable = false

  _gke_enable = local.gke_sample_enable ? ["enable"] : []
}

module "gke_sample" {
  for_each = toset(local._gke_enable)
  source   = "../modules/compute/gke"

  cluster = {
    name                      = "sample"
    location                  = "asia-northeast1"
    cluster_ipv4_cidr         = "10.0.0.0/9"
    default_max_pods_per_node = 110
    networking_mode           = null
    network                   = module.gke_network_sample["enable"].self_link
    subnetwork                = module.gke_network_sample["enable"].subnetwork_self_link["sample"]
    master_ipv4_cidr_block    = null
  }

  node_pool = [
    {
      name               = "sample"
      location           = "asia-northeast1"
      initial_node_count = 1
      node_locations = [
        "asia-northeast1-b"
      ]
      disk_size_gb = 10
      disk_type    = "pd-standard"
      image_type   = null
      machine_type = "n1-standard-2"
      tags         = []
    }
  ]
  service_account = module.gke_sa_sample["enable"].email
  node_count      = 2

  preemptible = {
    sample = true
  }
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

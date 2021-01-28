locals {
  enable = false

  prefix  = "exercises"
  _enable = local.enable ? [local.prefix] : []
}

module "gke" {
  for_each = toset(local._enable)
  source   = "github.com/AtsushiKitano/assets/terraform/gcp/modules/compute/gke"

  cluster = {
    name                      = join("-", [local.prefix, "cluster"])
    location                  = "asia-northeast1"
    cluster_ipv4_cidr         = "10.0.0.0/9"
    default_max_pods_per_node = 110
    networking_mode           = null
    network                   = module.network[local.prefix].self_link
    subnetwork                = module.network[local.prefix].subnetwork_self_link[local.prefix]
    master_ipv4_cidr_block    = null
  }

  node_pool = [
    {
      name               = join("-", [local.prefix, "node"])
      location           = "asia-northeast1"
      initial_node_count = 1
      node_locations = [
        "asia-northeast1-b"
      ]
      disk_size_gb = 10
      disk_type    = "pd-standard"
      image_type   = null
      machine_type = "n1-standard-1"
      tags         = []
    }
  ]
  service_account = module.service_account[local.prefix].email
  node_count      = 1

  preemptible = {
    join("-", [local.prefix, "node"]) = true
  }
}

module "network" {
  for_each = toset(local._enable)
  source   = "github.com/AtsushiKitano/assets/terraform/gcp/modules/network/vpc_network"

  project = terraform.workspace

  vpc_network = {
    name = local.prefix
  }
  subnetworks = [
    {
      name   = local.prefix
      cidr   = "192.168.10.0/24"
      region = "asia-northeast1"
    },
  ]

  firewall = [
    {
      direction = "INGRESS"
      name      = local.prefix
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

module "service_account" {
  for_each = toset(local._enable)

  source = "github.com/AtsushiKitano/assets/terraform/gcp/modules/iam/service_account"

  service_account = {
    name = "gke-exercises"
    roles = [
      "editor"
    ]
  }
}

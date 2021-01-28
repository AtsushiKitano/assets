locals {
  url_prefix = "../../../cluster/gcp/modules"
  machine_type = "n1-standard-1"
  node_count   = 1
  location     = "asia-northeast1"
  oauth_scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

module "network" {
  source = "../../../cluster/gcp/modules/network"

  vpc_nw_name = "gke"
  subnetwork_config = {
    name     = "gke-subnet"
    ip_range = "192.168.0.0/24"
    region   = "asia-northeast1"
  }

  fw_configs = [
    {
      name           = "gke-node-ssh"
      priority       = 1000
      target_tags    = []
      source_ranges  = ["0.0.0.0/0"]
      source_tags    = null
      enable_logging = false
      rules = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    }
  ]
}

module "gke" {
  source = "../../../cluster/gcp/modules/gke"

  gke_config = {
    name                      = "demo"
    location                  = local.location
    remove_default_node_pool  = true
    cluster_ip                = "172.16.0.0/16"
    service_ip                = "10.10.0.0/16"
    network                   = module.network.network_self_link
    subnetwork                = module.network.subnetwork_self_link
    initial_node_count        = 1
    oauth_scopes              = local.oauth_scopes
    default_max_pods_per_node = null
  }

  node_pool_configs = [
    {
      name         = "demo"
      location     = local.location
      node_count   = local.node_count
      preemptible  = true
      machine_type = local.machine_type
      oauth_scopes = local.oauth_scopes
    }
  ]
}

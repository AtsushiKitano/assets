locals {
  gke = {
    node_count = 1
    machine_type = "n1-standard-1"
    tag = "gke-cluster"
  }
}

resource "google_container_cluster" "private" {
  provider = "google-beta"

  name = "demo"
  location = local.location.zone

  remove_default_node_pool = true
  initial_node_count = 1

  network = google_compute_network.gke.self_link
  subnetwork = google_compute_subnetwork.gke.self_link

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "172.16.0.0/16"
    services_ipv4_cidr_block = "10.10.0.0/16"
  }

  node_config {
    preemptible = true
    tags = [
      local.gke.tag
    ]
    machine_type = local.gke.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }

  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "10.0.0.0/28"
  }

  release_channel {
    channel = "RAPID"
  }
}

resource "google_container_node_pool" "private_preemptible_node" {
  name = "demo"
  location = local.location.zone
  cluster = google_container_cluster.private.name
  node_count = local.gke.node_count

  node_config {
    preemptible = true
    tags = [
      local.gke.tag
    ]
  }
}

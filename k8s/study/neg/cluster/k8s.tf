locals {
  location = "asia-northeast1-b"
  machine_type = "n1-standard-1"
  node_count = 1
  tag = "gke-cluster"
}

resource "google_container_cluster" "primary" {
  name = "demo"
  location = local.location

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
      local.tag
    ]

    machine_type = local.machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "primary_preemptible_node" {
  name = "demo"
  location = local.location
  cluster = google_container_cluster.primary.name
  node_count = local.node_count

  node_config {
    preemptible = true
    tags = [
      local.tag
    ]
  }
}

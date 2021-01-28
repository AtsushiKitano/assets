resource "google_compute_network" "gke" {
  name = "gke-cluster"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke" {
  ip_cidr_range = "192.168.10.0/24"
  name = "gke-cluster"
  network = google_compute_network.gke.id
  region = "asia-northeast1"
}

data "google_netblock_ip_ranges" "lb-netblocks" {
  range_type = "health-checkers"
}

resource "google_compute_firewall" "neg-lb" {
  name           = "health-check-4-gke-cluster-pod"
  network        = google_compute_network.gke.name
  priority       = 1000
  direction      = "INGRESS"
  target_tags    = [
    local.tag
  ]
  source_ranges  = data.google_netblock_ip_ranges.lb-netblocks.cidr_blocks_ipv4

  allow {
    protocol = "tcp"
    ports = ["80"]
  }
}

resource "google_compute_firewall" "neg-ssh-bation" {
  name           = "ssh-bation-gke-cluster-nw"
  network        = google_compute_network.gke.name
  priority       = 1000
  direction      = "INGRESS"
  target_tags    = [
    local.gce.tag
  ]
  source_ranges  = [
    "0.0.0.0/0"
  ]

  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}


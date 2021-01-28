resource "google_compute_network" "gke" {
  name = "gke-cluster"
  auto_create_subnetworks = false
}

resource "google_compute_network" "private" {
  name = "private"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke" {
  ip_cidr_range = "192.168.10.0/24"
  name = "gke-cluster"
  network = google_compute_network.gke.id
  region = "asia-northeast1"
}

resource "google_compute_subnetwork" "private" {
  ip_cidr_range = "192.168.20.0/24"
  name = "private"
  network = google_compute_network.private.id
  region = "asia-northeast1"
}


resource "google_compute_firewall" "internet-ingress-gke" {
  name           = "ssh-from-internet-gke"
  network        = google_compute_network.gke.name
  priority       = 1000
  enable_logging = true
  direction      = "INGRESS"
  target_tags    = []
  source_ranges  = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "internet-ingress-pv" {
  name           = "ssh-from-internet-pv"
  network        = google_compute_network.private.name
  priority       = 1000
  enable_logging = true
  direction      = "INGRESS"
  target_tags    = []
  source_ranges  = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
  }
}


resource "google_compute_firewall" "gke2private" {
  name           = "gke2private"
  network        = google_compute_network.gke.name
  priority       = 1000
  enable_logging = true
  direction      = "INGRESS"
  target_tags    = []
  source_ranges  = ["192.168.20.0/24"]

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "icmp"
  }

}


resource "google_compute_firewall" "private2gke" {
  name           = "private2gke"
  network        = google_compute_network.private.name
  priority       = 1000
  enable_logging = true
  direction      = "INGRESS"
  target_tags    = []
  source_ranges  = ["192.168.10.0/24"]

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "icmp"
  }

}


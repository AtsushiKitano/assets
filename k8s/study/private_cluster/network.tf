resource "google_compute_network" "gke" {
  name = "gke-cluster"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke" {
  ip_cidr_range = "192.168.10.0/24"
  name = "gke-cluster"
  network = google_compute_network.gke.id
  region = local.location.region
  private_ip_google_access = true
}

resource "google_compute_firewall" "internet-ingress-gke" {
  name = "ssh-from-internet-gke"
  network = google_compute_network.gke.name
  priority = 1000
  direction = "INGRESS"
  target_tags = []
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
  }
}

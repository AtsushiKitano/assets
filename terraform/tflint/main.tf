resource "google_compute_instance" "main" {
  name         = "main"
  machine_type = "f1-micro"
  zone         = "asia-northeast1-c"

  tags = ["sample"]

  labels = {
    env = "dev"
  }

  network_interface {
    subnetwork = "default"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
}

resource "google_compute_network" "main" {
  name                    = "sample"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "sample"
  ip_cidr_range = "192.168.10.0/24"
  network       = google_compute_network.main.self_link
  region        = "asia-northeast1"
}

resource "google_compute_firewall" "main" {
  name          = "sample-error-fw"
  network       = google_compute_network.main.self_link
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"] #tfsec:ignore:GCP003

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

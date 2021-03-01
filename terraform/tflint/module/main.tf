resource "google_compute_instance" "main" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  tags   = var.tags
  labels = var.labels

  network_interface {
    subnetwork = var.subnetwork
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }
}

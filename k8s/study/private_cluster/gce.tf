locals {
  gce = {
    image = "debian-cloud/debian-9"
    machine_type = "f1-micro"
  }
}

resource "google_compute_instance" "bastion" {
  name         = "neg"
  machine_type = local.gce.machine_type

  boot_disk {
    initialize_params {
      image = local.gce.image
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.gke.self_link
    access_config {
    }
  }
}

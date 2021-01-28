provider "google" {
  region = "us-east1"
  project = terraform.workspace
}

resource "google_compute_instance" "example" {
  name         = "test"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}

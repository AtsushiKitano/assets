locals {
  neg_name = "k8s1-2b19b772-default-neg-demo-sv-80-a8def4e4"
  gce = {
    image = "debian-cloud/debian-9"
    machine_type = "f1-micro"
    tag = "bation"
  }
}

data "google_compute_network_endpoint_group" "neg" {
  name = local.neg_name
}

resource "google_compute_backend_service" "neg" {
  provider = google-beta

  name            = "neg"
  protocol        = "HTTP"
  health_checks = [
    google_compute_health_check.neg.self_link
  ]

  backend {
    balancing_mode = "RATE"
    max_rate_per_endpoint = 5
    group = data.google_compute_network_endpoint_group.neg.self_link
  }

  backend {
    balancing_mode = "RATE"
    max_rate_per_endpoint = 5
    group = google_compute_network_endpoint_group.neg.self_link
  }
}

resource "google_compute_network_endpoint_group" "neg" {
  name = "neg-vm"
  network = google_compute_network.gke.id
  network_endpoint_type = "GCE_VM_IP_PORT"
  subnetwork = google_compute_subnetwork.gke.id
  default_port = "80"
}

resource "google_compute_network_endpoint" "neg" {
  network_endpoint_group = google_compute_network_endpoint_group.neg.name

  instance = google_compute_instance.bastion.name
  port = google_compute_network_endpoint_group.neg.default_port
  ip_address = google_compute_instance.bastion.network_interface[0].network_ip
}

resource "google_compute_instance" "bastion" {
  name         = "neg"
  machine_type = local.gce.machine_type

  tags = [
    local.gce.tag,
    local.tag
  ]

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

resource "google_compute_global_address" "neg" {
  name         = "neg"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_global_forwarding_rule" "neg" {
  name                  = "neg"
  target                = google_compute_target_http_proxy.neg.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.neg.address
}

resource "google_compute_target_http_proxy" "neg" {
  name = "neg"
  url_map = google_compute_url_map.neg.self_link
}

resource "google_compute_url_map" "neg" {
  name            = "neg"
  default_service = google_compute_backend_service.neg.self_link
}

resource "google_compute_health_check" "neg" {
  name = "neg-health-check"

  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}


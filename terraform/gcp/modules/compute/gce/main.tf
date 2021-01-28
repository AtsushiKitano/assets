locals {
  _service_account = var.service_account != null ? [
    {
      service_account = var.service_account
      scopes          = var.scopes
    }
  ] : []
}

resource "google_compute_instance" "main" {
  name         = var.gce_instance.name
  machine_type = var.gce_instance.machine_type
  zone         = var.gce_instance.zone
  project      = var.project
  tags         = var.gce_instance.tags

  network_interface {
    subnetwork = var.gce_instance.subnetwork
    network_ip = var.private_ip

    dynamic "access_config" {
      for_each = var.access_config ? ["enable"] : []
      iterator = _conf

      content {
        nat_ip                 = var.nat_ip
        public_ptr_domain_name = var.public_ptr_domain_name
        network_tier           = var.network_tier
      }
    }
  }

  boot_disk {
    auto_delete = var.boot_disk_auto_delete
    device_name = var.boot_disk_device_name
    source      = google_compute_disk.boot_disk.self_link
  }

  dynamic "attached_disk" {
    for_each = { for v in var.attached_disk : v.name => v }
    iterator = _conf

    content {
      source      = google_compute_attached_disk.attached_disk[_conf.value.name].self_link
      device_name = _conf.value.name
      mode        = _conf.value.mode
    }
  }

  dynamic "scheduling" {
    for_each = var.scheduling ? ["enable"] : []

    content {
      preemptible         = var.preemptible
      on_host_maintenance = var.on_host_maintenance
      automatic_restart   = var.automatic_restart
    }
  }

  dynamic "service_account" {
    for_each = local._service_account
    iterator = _conf

    content {
      email  = _conf.value.service_account
      scopes = _conf.value.scopes
    }
  }

  dynamic "guest_accelerator" {
    for_each = var.accelerator != null ? [var.accelerator] : []
    iterator = _conf

    content {
      type  = _conf.value.type
      count = _conf.value.count
    }
  }
}

resource "google_compute_disk" "boot_disk" {
  provider = google-beta

  name      = var.boot_disk.name
  size      = var.boot_disk.size
  interface = var.boot_disk.interface
  image     = var.boot_disk.image
  zone      = var.gce_instance.zone
  project   = var.project
}

resource "google_compute_disk" "attached_disk" {
  for_each = { for v in var.attached_disk : v.name => v }
  provider = google-beta

  name      = each.value.name
  size      = each.value.size
  interface = each.value.interface
  zone      = var.gce_instance.zone
  project   = var.project
}

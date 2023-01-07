locals {
  _service_account = var.service_account != null ? [
    {
      service_account = var.service_account
      scopes          = var.scopes
    }
  ] : []
}

resource "google_compute_instance" "main" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project
  tags         = var.tags

  metadata                  = var.metadata
  metadata_startup_script   = var.startup_script
  allow_stopping_for_update = var.allow_stopping_for_update

  network_interface {
    subnetwork = var.subnetwork
    network_ip = var.private_ip

    dynamic "access_config" {
      for_each = var.access_config ? ["enable"] : []
      iterator = _conf

      content {
        nat_ip                 = var.enabled_nat ? google_compute_address.main[var.name].address : null
        public_ptr_domain_name = var.public_ptr_domain_name
        network_tier           = var.network_tier
      }
    }
  }

  boot_disk {
    auto_delete = var.boot_disk_auto_delete
    device_name = var.boot_disk_device_name != null ? var.boot_disk_device_name : format("%s-boot-disk", var.name)
    source      = google_compute_disk.boot_disk.self_link
  }

  dynamic "attached_disk" {
    for_each = { for v in var.attached_disks : v.name => v }
    iterator = _conf

    content {
      source      = google_compute_disk.attached_disk[_conf.value.name].self_link
      device_name = _conf.value.name
      mode        = _conf.value.mode
    }
  }

  dynamic "scheduling" {
    for_each = var.enabled_scheduling ? ["enable"] : []

    content {
      preemptible         = var.preemptible
      on_host_maintenance = var.on_host_maintenance
      automatic_restart   = var.automatic_restart
    }
  }

  service_account {
    email  = var.service_account
    scopes = var.scopes
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
  name    = format("%s-bootdisk", var.name)
  size    = var.size
  image   = var.image
  zone    = var.zone
  project = var.project
}

resource "google_compute_disk" "attached_disk" {
  for_each = { for v in var.attached_disks : v.name => v }

  name    = each.value.name
  size    = each.value.size
  type    = each.value.type
  zone    = var.zone
  project = var.project
}

resource "google_compute_address" "main" {
  for_each = var.enabled_nat ? toset([var.name]) : []

  name         = each.value
  address      = var.external_ip_address
  address_type = var.external_ip_type
  purpose      = var.external_ip_purpose
  network_tier = var.external_ip_network_tier
  subnetwork   = var.external_ip_type == "INTERNAL" ? var.external_ip_subnetwork : null
  region       = var.external_ip_region
}

resource "google_compute_instance_template" "main" {
  name_prefix    = var.name
  machine_type   = var.machine_type
  can_ip_forward = var.can_ip_forward
  project        = var.project
  region         = var.region

  metadata_startup_script = var.startup_script
  metadata                = var.metadata
  tags                    = var.tags

  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = var.subnetwork_project
    network_ip         = var.network_ip

    dynamic "access_config" {
      for_each = var.access_config != null ? [var.access_config] : []
      iterator = _conf

      content {
        nat_ip       = _conf.value.nat_ip
        network_tier = _conf.value.network_tier
      }
    }

    dynamic "alias_ip_range" {
      for_each = var.alias_ip_range != null ? [var.alias_ip_range] : []
      iterator = _conf

      content {
        ip_cidr_range         = _conf.value.ip_cidr_range
        subnetwork_range_name = _conf.value.subnetwork_range_name
      }
    }
  }

  disk {
    auto_delete  = var.auto_delete
    source_image = var.source_image
    device_name  = var.device_name
    disk_name    = var.disk_name
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size
    interface    = var.disk_interface
    mode         = var.disk_mode
    type         = var.disk_type

    dynamic "disk_encryption_key" {
      for_each = var.encryption_key != null ? ["dummy"] : []

      content {
        kms_key_self_link = var.encryption_key
      }
    }
  }

  dynamic "scheduling" {
    for_each = var.scheduling_elabled ? ["dummy"] : []
    iterator = _conf

    content {
      automatic_restart   = var.automatic_restart
      on_host_maintenance = var.on_host_maintenance
      preemptible         = var.preemptible
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

  dynamic "shielded_instance_config" {
    for_each = var.shielded_instance_enabled != null ? [var.shielded_instance] : []
    iterator = _conf

    content {
      enable_secure_boot          = var.secure_boot_enabled
      enable_vtpm                 = var.vtpm_enabled
      enable_integrity_monitoring = var.integrity_monitoring_enabled
    }
  }
}

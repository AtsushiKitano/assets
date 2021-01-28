resource "google_compute_instance_template" "main" {
  name_prefix    = var.instance_template.name
  machine_type   = var.instance_template.machine_type
  can_ip_forward = var.instance_template.can_ip_forward
  project        = var.project
  region         = var.region

  metadata_startup_script = var.startup_script
  metadata                = var.metadata
  tags                    = var.instance_template.tags
  enable_display          = var.enable_display

  network_interface {
    network            = var.instance_template.subnetwork == null ? var.network : null
    subnetwork         = var.instance_template.subnetwork
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
    boot         = var.instance_template.disk.source_image == null && var.template_source == null ? var.boot : null
    device_name  = var.device_name
    disk_name    = var.disk_name
    disk_type    = var.disk_type
    source_image = var.instance_template.disk.source_image
    interface    = var.instance_template.disk.interface
    mode         = var.instance_template.disk.mode
    source       = var.instance_template.disk.source_image == null && var.boot == null ? var.template_source : null
    type         = var.instance_template.disk.type
    disk_size_gb = var.instance_template.disk.size

    dynamic "disk_encryption_key" {
      for_each = var.encryption_key != null ? [var.encryption_key] : []
      iterator = _conf

      content {
        kms_key_self_link = _conf.value
      }
    }
  }

  dynamic "scheduling" {
    for_each = var.scheduling != null ? [var.scheduling] : []
    iterator = _conf

    content {
      automatic_restart   = _conf.value.automatic_restart
      on_host_maintenance = _conf.value.on_host_maintenance
      preemptible         = _conf.value.preemptible

      dynamic "node_affinities" {
        for_each = var.node_affinities != null ? [var.node_affinities] : []
        iterator = _var

        content {
          key      = _var.value.key
          operator = _var.value.operator
          values   = _var.value.affinity_value
        }
      }
    }
  }

  dynamic "service_account" {
    for_each = var.service_account != null ? [var.service_account] : []
    iterator = _conf

    content {
      email  = _conf.value
      scopes = var.scopes
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

  dynamic "shielded_instance_config" {
    for_each = var.shielded_instance != null ? [var.shielded_instance] : []
    iterator = _conf

    content {
      enable_secure_boot          = _conf.value.enable_secure_boot
      enable_vtpm                 = _conf.value.enable_vtpm
      enable_integrity_monitoring = _conf.value.enable_integrity_monitoring
    }
  }
}
